import 'package:flutter/material.dart';
import 'routes.dart';
import '../core/constants/colors.dart';

class EVCommunityApp extends StatelessWidget {
  const EVCommunityApp({super.key});

  /// Global navigator key (useful for push notifications later)
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoltShare',
      debugShowCheckedModeBanner: false,

      navigatorKey: navigatorKey,

      /// GLOBAL THEME
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',

        scaffoldBackgroundColor: AppColors.background,

        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryPurple,
          secondary: AppColors.secondaryGreen,
        ),

        /// APP BAR
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),

        /// INPUT FIELDS
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

        /// BUTTON STYLE
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

      /// ROUTING
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
