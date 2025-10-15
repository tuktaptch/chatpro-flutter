import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/widgets/c_app_bar.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/main_screen/setting';
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isDarkMode = false;
  //get the save theme mode
  void getThemeMode() async {
    final saveThemeMode = await AdaptiveTheme.getThemeMode();
    if (saveThemeMode == AdaptiveThemeMode.dark) {
      setState(() {
        isDarkMode = true;
      });
    } else {
      setState(() {
        isDarkMode = false;
      });
    }
  }

  @override
  void initState() {
    getThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(title: 'Setting'),
      body: Card(
        child: SwitchListTile(
          secondary: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? CColors.pureWhite : CColors.lightPink,
            ),
            child: Icon(
              isDarkMode ? Icons.nightlight_round : Icons.wb_sunny_rounded,
              color: isDarkMode ? CColors.hotPink : CColors.vividPink,
            ),
          ),
          title: Text(
            'Dark Mode',
            style: CTypography.title.copyWith(
              color: isDarkMode ? CColors.pureWhite : CColors.darkGray,
            ),
          ),
          value: isDarkMode,
          onChanged: (value) {
            setState(() {
              isDarkMode = value;
            });
            if (value) {
              AdaptiveTheme.of(context).setDark();
            } else {
              AdaptiveTheme.of(context).setLight();
            }
          },
        ),
      ),
    );
  }
}

class SettingScreenArguments {
  String uid;
  SettingScreenArguments({required this.uid});
}
