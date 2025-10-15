import 'package:chat_pro/authentication/landing_page_screen.dart';
import 'package:chat_pro/authentication/login/login_screen.dart';
import 'package:chat_pro/authentication/login/login_screen_provider.dart';
import 'package:chat_pro/authentication/otp/otp_screen.dart';
import 'package:chat_pro/authentication/otp/otp_screen_provider.dart';
import 'package:chat_pro/authentication/user_information.dart/user_information_screen.dart';
import 'package:chat_pro/authentication/user_information.dart/user_information_screen_provider.dart';
import 'package:chat_pro/main_screen/home_screen/home_screen.dart';
import 'package:chat_pro/main_screen/home_screen/home_screen_provider.dart';
import 'package:chat_pro/main_screen/profile_screen/profile_screen.dart';
import 'package:chat_pro/main_screen/profile_screen/profile_screen_provider.dart';
import 'package:chat_pro/main_screen/setting_screen.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatProRoute {
  // ใช้ static method แทนการสร้าง instance
  // เพื่อให้สามารถเรียกใช้ได้โดยไม่ต้องสร้าง object
  //ถ้า Provider ของคุณไม่ต้องพึ่ง provider อื่น → ใช้ ChangeNotifierProvider พอ
  //ถ้า Provider ของคุณต้องพึ่ง provider อื่น → ใช้ ChangeNotifierProxyProvider
  //ถ้า ไม่พึ่งใครแต่ต้องการ update logic ทุกครั้ง → ใช้ ChangeNotifierProxyProvider0
  Map<String, WidgetBuilder> routes() => {
    LandingPageScreen.routeName: (context) => LandingPageScreen(),
    LoginScreen.routeName: (context) => ChangeNotifierProvider(
      create: (_) => LoginScreenProvider(),
      child: const LoginScreen(),
    ),

    OtpScreen.routeName: (context) => ChangeNotifierProvider(
      create: (_) => OtpScreenProvider(context.read<AuthenticationProvider>()),
      child: const OtpScreen(),
    ),
    UserInformationScreen.routeName: (context) => ChangeNotifierProvider(
      create: (_) =>
          UserInformationScreenProvider(context.read<AuthenticationProvider>()),
      child: const UserInformationScreen(),
    ),
    HomeScreen.routeName: (context) => ChangeNotifierProvider(
      create: (_) => HomeScreenProvider(context.read<AuthenticationProvider>()),
      child: const HomeScreen(),
    ),
    ProfileScreen.routeName: (context) => ChangeNotifierProvider(
      create: (_) =>
          ProfileScreenProvider(context.read<AuthenticationProvider>()),
      child: ProfileScreen(),
    ),
    SettingScreen.routeName: (context) => SettingScreen(),
  };
}
