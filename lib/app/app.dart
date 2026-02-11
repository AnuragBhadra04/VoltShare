import 'package:flutter/material.dart';
import 'routes.dart';
import '../core/constants/colors.dart';

class EVCommunityApp extends StatelessWidget {
  const EVCommunityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VoltShare',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryPurple,
          secondary: AppColors.secondaryGreen,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
