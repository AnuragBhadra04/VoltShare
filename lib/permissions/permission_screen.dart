import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/constants/colors.dart';
import '../services/role_service.dart';
import '../provider/provider_home_screen.dart';
import '../taker/taker_home_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  Future<void> _allow() async {
    // 🔐 Request permissions
    await [
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.notification,
    ].request();

    // 🔍 Get role
    final role = await RoleService.getRole();

    if (!mounted) return;

    // 🚀 Navigate
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => role == 'provider'
            ? const ProviderHomeScreen()
            : const TakerHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: AppColors.primaryPurple,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Permissions Required',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleText,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Location, camera & notifications help us serve you better.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.subtitleText),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _allow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Allow & Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
