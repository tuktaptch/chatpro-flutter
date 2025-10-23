import 'package:chat_pro/ui/authentication/otp/otp_screen.dart';
import 'package:chat_pro/ui/authentication/user_information.dart/user_information_screen.dart';
import 'package:chat_pro/ui/home_screen/home_screen.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/widgets/custom_pinput/c_custom_pinput_controller.dart';
import 'package:flutter/material.dart';

class OtpScreenProvider with ChangeNotifier {
  final AuthenticationProvider _authProvider;
  OtpScreenProvider(this._authProvider);
  String _otp = '';
  String get otp => _otp;
  String _verificationId = '';
  String get verificationId => _verificationId;
  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;
  final CPinPutController myPinController = CPinPutController();

  void init(OtpScreenArguments args) {
    _verificationId = args.verificationId;
    _phoneNumber = args.phoneNumber;
    notifyListeners();
  }

  void updateOtp(String value, BuildContext context) {
    _otp = value;
    notifyListeners();
    verifyOtp(context);
  }

  Future<void> verifyOtp(BuildContext context) async {
    await _authProvider.verifyOtpCode(
      verificationId: _verificationId,
      smsCode: _otp,
      context: context,
      onSuccess: () async {
        //1. check if user exists in firestore.
        bool userExists = await _authProvider.checkUserExists();

        if (userExists) {
          //2. if exists.
          //* get user information on firestore.
          await _authProvider.fetchUserDataFromFireStore();
          //save user information to provider/share preference.
          await _authProvider.saveUserDataToSharedPreference();
          //navigate to home screen.
          if (context.mounted) return navigate(true, context);
        } else {
          //3. if not, navigate to user information screen.
          if (context.mounted) return navigate(false, context);
        }
      },
    );
    notifyListeners();
  }

  void navigate(bool userExists, BuildContext context) {
    if (userExists) {
      //navigate to home screen.
      navigatorToHomeScreen(context);
      print('User exists, navigate to Home Screen');
    } else {
      //navigate to user information screen.
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          UserInformationScreen.routeName,
          arguments: UserInformationArguments(
            phoneNumber: _authProvider.phoneNumber ?? '',
          ),
        );
      }
    }
  }

  void navigatorToHomeScreen(BuildContext context) {
    // Navigate to HomeScreen and remove all previous routes.
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
  }

  void resendOtp() async {}

  @override
  void dispose() {
    myPinController.disposeAll();
    super.dispose();
  }
}
