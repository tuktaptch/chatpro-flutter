import 'package:chat_pro/ui/authentication/login/login_screen.dart';
import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/constraints/spacing.dart';
import 'package:chat_pro/ui/home_screen/home_screen.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/utilities/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LandingPageScreen extends StatefulWidget {
  static const routeName = '/authentication/landing_page';
  const LandingPageScreen({super.key});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  @override
  void initState() {
    checkAuthentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AssetsManager.landingPageImage,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Lottie.asset(AssetsManager.chatBubble),
                  ),
                  Text(
                    'Chat Pro',
                    style: CTypography.display1.copyWith(
                      color: CColors.hotPink,
                    ),
                  ),
                  ConstSpacer.height24(),
                  LinearProgressIndicator(
                    color: CColors.hotPink,
                    backgroundColor: CColors.lightPink,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkAuthentication() async {
    final authProvider = context.read<AuthenticationProvider>();
    //await authProvider.logOut();
    bool isAuthenticated = await authProvider.checkAuthenticationState();

    navigate(isAuthenticated: isAuthenticated);
  }

  navigate({required bool isAuthenticated}) {
    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }
}
