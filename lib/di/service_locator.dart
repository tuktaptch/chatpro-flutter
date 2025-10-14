import 'package:chat_pro/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Register services
  getIt.registerLazySingleton(() => NavigationService());
}
