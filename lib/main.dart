import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_pro/ui/authentication/landing_page_screen.dart';
import 'package:chat_pro/di/modules/service_locator.dart';
import 'package:chat_pro/firebase_options.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/provider/chat_provider.dart';
import 'package:chat_pro/route.dart';
import 'package:chat_pro/di/modules/services/navigation_service.dart';
import 'package:chat_pro/utilities/alert/toast_extension.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_pro/utilities/alert/toast_list_overlay.dart';
import 'package:chat_pro/utilities/alert/toast_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Setup service locator (DI)
  await setupLocator();

  // ✅ Get saved theme mode
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode});
  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat Pro',
        theme: light,
        darkTheme: dark,
        routes: ChatProRoute(context).routes(),
        initialRoute: LandingPageScreen.routeName,
        navigatorKey: getIt<NavigationService>().navigatorKey,

        // ✅ ToastListOverlay ครอบด้านใน MaterialApp
        builder: (context, child) {
          return ToastListOverlay<Toast>(
            itemBuilder: (context, item, animation) => ToastItem(
              animation: animation,
              item: item,
              onTap: () => context.hideToast<Toast>(item),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
