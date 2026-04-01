import 'package:flutter/material.dart';
import 'routes.dart';
import '../core/constants/colors.dart';
import '../splash/splash_screen.dart';

class EVCommunityApp extends StatelessWidget {
  const EVCommunityApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoltShare',
      debugShowCheckedModeBanner: false,
      navigatorKey: EVCommunityApp.navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryPurple,
          secondary: AppColors.secondaryGreen,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      },
    );
  }
}
