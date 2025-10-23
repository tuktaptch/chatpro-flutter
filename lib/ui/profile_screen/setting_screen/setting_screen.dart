import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/ui/profile_screen/setting_screen/setting_screen_provider.dart';
import 'package:chat_pro/widgets/c_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/main_screen/setting';
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.background,
      appBar: CAppBar(title: 'Setting', backgroundColor: CColors.background),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          color: CColors.pureWhite,
          shadowColor: CColors.darkGray.withAlpha(40),
          child: Selector<SettingScreenProvider, bool>(
            selector: (_, provider) => provider.isDarkMode,
            builder: (_, isDarkMode, __) {
              return SwitchListTile(
                secondary: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode ? CColors.pureWhite : CColors.lightPink,
                  ),
                  child: Icon(
                    isDarkMode
                        ? Icons.nightlight_round
                        : Icons.wb_sunny_rounded,
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
                onChanged: (value) =>
                    context.read<SettingScreenProvider>().toggleDarkMode(value),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SettingScreenArguments {
  String uid;
  SettingScreenArguments({required this.uid});
}
