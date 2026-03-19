import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/role_service.dart';
import '../provider/provider_home_screen.dart';
import '../consumer/consumer_home_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  Future<void> _allow() async {
    await [
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.notification,
    ].request();

    final role = await RoleService.getRole();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => role == 'provider'
            ? const ProviderHomeScreen()
            : const ConsumerHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        /// 🌈 Same Gradient Theme
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7A74D8),
              Color(0xFF5E8DAA),
              Color(0xFF5BC97C),
              Color(0xFF2F4F4F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),

            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// LOGO CARD
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/images/app_logo.png",
                        width: 130,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// TITLE
                  const Text(
                    "Permissions Required",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Location, camera and notifications help VoltShare\nprovide EV discovery and booking services.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                  ),

                  const SizedBox(height: 32),

                  /// PERMISSION LIST
                  Column(
                    children: const [
                      _PermissionItem(
                        icon: Icons.location_on,
                        title: "Location Access",
                        subtitle: "Find nearby EVs & chargers",
                      ),

                      SizedBox(height: 10),

                      _PermissionItem(
                        icon: Icons.camera_alt,
                        title: "Camera",
                        subtitle: "Scan QR for chargers",
                      ),

                      SizedBox(height: 10),

                      _PermissionItem(
                        icon: Icons.notifications,
                        title: "Notifications",
                        subtitle: "Booking updates & alerts",
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// ALLOW BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),

                      child: ElevatedButton(
                        onPressed: _allow,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),

                        child: const Text(
                          "Allow & Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// PERMISSION ITEM WIDGET
class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Icon(icon, color: Colors.white),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
