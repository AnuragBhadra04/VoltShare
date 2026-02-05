import 'package:flutter/material.dart';
import '../splash/splash_screen.dart';

class AppRoutes {
  static const splash = '/';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
  };
}
