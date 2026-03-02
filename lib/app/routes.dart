import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../splash/splash_screen.dart';
import '../role/role_selection_screen.dart';
import '../auth/auth_screen.dart';
import '../permissions/permission_screen.dart';
import '../consumer/consumer_home_screen.dart';
import '../provider/provider_home_screen.dart';
import '../map/map_screen.dart';

class AppRoutes {
  static const splash = "/";
  static const role = "/role";
  static const auth = "/auth";
  static const permission = "/permission";

  static const profile = "/profile";

  static const takerHome = "/takerHome";
  static const providerHome = "/providerHome";

  static const map = "/map";

  static const rating = "/rating"; // ✅ THIS WAS MISSING

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),

    role: (context) => const RoleSelectionScreen(),

    auth: (context) => const PhoneAuthScreen(),

    permission: (context) => const PermissionScreen(),

    profile: (context) => const ProfileScreen(),

    takerHome: (context) => const ConsumerHomeScreen(),

    providerHome: (context) => const ProviderHomeScreen(),

    map: (context) => const MapScreen(),
  };
}
