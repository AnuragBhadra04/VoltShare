import 'package:flutter/material.dart';

import '../splash/splash_screen.dart';
import '../role/role_selection_screen.dart';
import '../auth/signin_screen.dart';
import '../permissions/permission_screen.dart';

import '../consumer/consumer_home_screen.dart';
import '../provider/provider_home_screen.dart';

import '../profile/profile_screen.dart';
import '../map/map_screen.dart';

class AppRoutes {
  /// Core routes
  static const splash = "/";
  static const auth = "/auth";
  static const role = "/role";
  static const permission = "/permission";

  /// Main app routes
  static const consumerHome = "/consumerHome";
  static const providerHome = "/providerHome";

  /// Features
  static const map = "/map";
  static const profile = "/profile";

  /// Route Map
  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),

    /// Auth flow
    auth: (context) => const PhoneAuthScreen(),
    role: (context) => const RoleSelectionScreen(),
    permission: (context) => const PermissionScreen(),

    /// Main screens
    consumerHome: (context) => const ConsumerHomeScreen(),
    providerHome: (context) => const ProviderHomeScreen(),

    /// Utilities
    profile: (context) => const ProfileScreen(),
    map: (context) => const MapScreen(),
  };
}
