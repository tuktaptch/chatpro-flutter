import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_pro/authentication/landing_page_screen.dart';
import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/di/modules/service_locator.dart';
import 'package:chat_pro/firebase_options.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/provider/chat_provider.dart';
import 'package:chat_pro/route.dart';
import 'package:chat_pro/di/modules/services/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Setup service locator
  await setupLocator();
  // Get saved theme mode
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    // Setup Provider for global state management
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_)=>ChatProvider())
      ],
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode});
  final AdaptiveThemeMode? savedThemeMode;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: CColors.hotPink,
          brightness: Brightness.dark,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: CColors.pureWhite, // สีข้อความปกติ
          displayColor: CColors.pureWhite, // สีหัวข้อใหญ่ ๆ
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat Pro',
        theme: light,
        darkTheme: dark,
        //home: UserInformationScreen(),
        routes: ChatProRoute().routes(),
        initialRoute: LandingPageScreen.routeName,
        // Use the navigator key from NavigationService
        navigatorKey: getIt<NavigationService>().navigatorKey,
      ),
    );
  }
}
