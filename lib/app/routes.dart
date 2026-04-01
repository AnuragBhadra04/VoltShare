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
  /// CORE FLOW
  static const splash = "/";
  static const auth = "/auth";
  static const role = "/role";
  static const permission = "/permission";

  /// DASHBOARDS
  static const consumerHome = "/consumerHome";
  static const providerHome = "/providerHome";

  /// EXTRA
  static const profile = "/profile";
  static const map = "/map";

  /// ROUTE MAP
  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),

    /// AUTH FLOW
    auth: (_) => const PhoneAuthScreen(),
    role: (_) => const RoleSelectionScreen(),
    permission: (_) => const PermissionScreen(),

    /// MAIN
    consumerHome: (_) => const ConsumerHomeScreen(),
    providerHome: (_) => const ProviderHomeScreen(),

    /// EXTRA
    profile: (_) => const ProfileScreen(),
    map: (_) => const MapScreen(),
  };
}
