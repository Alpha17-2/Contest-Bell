import 'package:get/get.dart';

import '../view/home_screen.dart';
import '../view/splash_screen.dart';


class AppRoutes {
  static const String home = '/home';
  static const String splash = '/splash';

  static List<GetPage> getPages() {
    return [
      GetPage(
        name: home,
        page: () => HomeScreen(),
      ),
      GetPage(
        name: splash,
        page: () => SplashScreen(),
      ),
    ];
  }
}