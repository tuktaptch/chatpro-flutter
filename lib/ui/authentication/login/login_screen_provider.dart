import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreenProvider with ChangeNotifier {
  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;
  final String _countryCode = '+66';
  String get countryCode => _countryCode;
  Country selectedCountry = Country(
    phoneCode: '66',
    countryCode: 'TH',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Thailand',
    example: '812345678',
    displayName: 'Thailand (TH) [+66]',
    displayNameNoCountryCode: 'TH',
    e164Key: '',
  );
  TextEditingController controller = TextEditingController();
  RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();

  void updateSelectedCountry(Country country) {
    selectedCountry = country;
    notifyListeners();
  }

  void updatePhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    buttonController.stop();
    super.dispose();
  }
}
