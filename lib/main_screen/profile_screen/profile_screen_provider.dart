import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:flutter/material.dart';

class ProfileScreenProvider with ChangeNotifier {
  final AuthenticationProvider _authenticationProvider;
  ProfileScreenProvider(this._authenticationProvider);
  String _uid = '';
  String get uid => _uid;

  void init(String uid) {
    _uid = uid;
    notifyListeners();
  }
}
