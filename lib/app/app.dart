import 'package:flutter/material.dart';
import 'routes.dart';

class EVCommunityApp extends StatelessWidget {
  const EVCommunityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV Community App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
