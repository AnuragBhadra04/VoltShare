import 'package:flutter/material.dart';
import 'routes.dart';
import '../core/constants/colors.dart';

class EVCommunityApp extends StatelessWidget {
  const EVCommunityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoltShare',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'Roboto',

        scaffoldBackgroundColor: AppColors.background,

        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryPurple,
          secondary: AppColors.secondaryGreen,
        ),

        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      ),

      initialRoute: AppRoutes.splash,

      routes: AppRoutes.routes,
    );
  }
}
