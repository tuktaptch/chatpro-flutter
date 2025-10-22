import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class SettingScreenProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  final BuildContext context;

  SettingScreenProvider(this.context) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final savedTheme = await AdaptiveTheme.getThemeMode();
    _isDarkMode = savedTheme == AdaptiveThemeMode.dark;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    if (value) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
    notifyListeners();
  }
}
