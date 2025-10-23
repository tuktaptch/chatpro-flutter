import 'package:chat_pro/ui/authentication/landing_page_screen.dart';
import 'package:chat_pro/ui/authentication/login/login_screen.dart';
import 'package:chat_pro/ui/authentication/login/login_screen_provider.dart';
import 'package:chat_pro/ui/authentication/otp/otp_screen.dart';
import 'package:chat_pro/ui/authentication/otp/otp_screen_provider.dart';
import 'package:chat_pro/ui/authentication/user_information.dart/user_information_screen.dart';
import 'package:chat_pro/ui/authentication/user_information.dart/user_information_screen_provider.dart';
import 'package:chat_pro/ui/chat_screen/chat_screen.dart';
import 'package:chat_pro/ui/chat_screen/chat_screen_provider.dart';
import 'package:chat_pro/ui/friend_request_screen/friend_request_provider.dart';
import 'package:chat_pro/ui/friend_request_screen/friend_request_screen.dart';
import 'package:chat_pro/ui/friend_screen/friend_screen.dart';
import 'package:chat_pro/ui/friend_screen/friend_screen_provider.dart';
import 'package:chat_pro/ui/home_screen/home_screen.dart';
import 'package:chat_pro/ui/home_screen/home_screen_provider.dart';
import 'package:chat_pro/ui/home_screen/my_chats_screen/my_chats_screen.dart';
import 'package:chat_pro/ui/home_screen/my_chats_screen/my_chats_screen_providet.dart';
import 'package:chat_pro/ui/home_screen/people_screen/people_screen.dart';
import 'package:chat_pro/ui/home_screen/people_screen/people_screen_provider.dart';
import 'package:chat_pro/ui/profile_screen/profile_screen.dart';
import 'package:chat_pro/ui/profile_screen/profile_screen_provider.dart';
import 'package:chat_pro/ui/profile_screen/setting_screen/setting_screen.dart';
import 'package:chat_pro/ui/profile_screen/setting_screen/setting_screen_provider.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatProRoute {
  final BuildContext _context;
  ChatProRoute(this._context);
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
    SettingScreen.routeName: (context) => ChangeNotifierProvider(
      create: (context) => SettingScreenProvider(context),
      child: SettingScreen(),
    ),
    FriendScreen.routeName: (context) => ChangeNotifierProvider(
      create: (context) => FriendScreenProvider(),
      child: FriendScreen(),
    ),
    FriendRequestScreen.routeName: (context) => ChangeNotifierProvider(
      create: (context) => FriendRequestProvider(),
      child: FriendRequestScreen(),
    ),
    ChatScreen.routeName: (context) => ChangeNotifierProvider(
      create: (context) => ChatScreenProvider(),
      child: ChatScreen(),
    ),
    PeopleScreen.routeName: (context) => ChangeNotifierProvider(
      create: (context) =>
          PeopleScreenProvider(context.read<AuthenticationProvider>()),
      child: PeopleScreen(),
    ),
    MyChatsScreen.routeName: (context) => ChangeNotifierProvider(
      create: (context) => MyChatsScreenProvider(
        context.read<ChatProvider>(),
        context.read<AuthenticationProvider>(),
      ),
      child: MyChatsScreen(),
    ),
  };
}
