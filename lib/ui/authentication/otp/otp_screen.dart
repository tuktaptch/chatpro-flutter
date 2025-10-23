import 'package:chat_pro/ui/authentication/otp/otp_screen_provider.dart';
import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/constraints/spacing.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/utilities/assets_manager.dart';
import 'package:chat_pro/widgets/custom_pinput/c_custom_pinput.dart';
import 'package:chat_pro/widgets/linear_gradient_bg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  static const String routeName = '/authentication/otp';
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as OtpScreenArguments;
      context.read<OtpScreenProvider>().init(args);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [const LinearGradientBackground(), OtpForm()]),
    );
  }
}

class OtpForm extends StatelessWidget {
  const OtpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authProvider = context
        .watch<AuthenticationProvider>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  ConstSpacer.height16(),
                  Image.asset(AssetsManager.oTPImage, fit: BoxFit.cover),
                  ConstSpacer.height16(),
                  Text(
                    'Verification',
                    style: CTypography.display2.copyWith(
                      color: CColors.hotPink,
                    ),
                  ),
                  ConstSpacer.height16(),
                  Text(
                    'Enter the 6-digit code sent to number',
                    style: CTypography.title.copyWith(color: CColors.darkGray),
                  ),
                  ConstSpacer.height8(),
                  Text(
                    '+66 812345678',
                    style: CTypography.title.copyWith(
                      color: CColors.salmonPink,
                    ),
                  ),
                  ConstSpacer.height16(),
                  CPinPut(
                    controller: context
                        .read<OtpScreenProvider>()
                        .myPinController,
                    length: 6,
                    onCompleted: (pin) => context
                        .read<OtpScreenProvider>()
                        .updateOtp(pin, context), // อัปเดตรหัส OTP
                  ),
                  ConstSpacer.height16(),
                  authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : const SizedBox.shrink(),
                  ConstSpacer.height16(),
                  authProvider.isSuccessful
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: CColors.green,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: CColors.pureWhite,
                          ),
                        )
                      : SizedBox.shrink(),
                  ConstSpacer.height16(),
                  authProvider.isLoading
                      ? SizedBox.shrink()
                      : Text(
                          'Didn\'t receive the code?',
                          style: CTypography.body1.copyWith(
                            color: CColors.darkGray,
                          ),
                        ),
                  ConstSpacer.height8(),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.center,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Resend Code',
                      style: CTypography.body1.copyWith(
                        color: CColors.pinkOrange,
                        decoration: TextDecoration.underline,
                        decorationColor: CColors.pinkOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OtpScreenArguments {
  final String verificationId;
  final String phoneNumber;
  OtpScreenArguments({required this.verificationId, required this.phoneNumber});
}
