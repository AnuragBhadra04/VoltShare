import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/role_service.dart';
import '../auth/signin_screen.dart';
import '../consumer/consumer_home_screen.dart';
import '../provider/provider_home_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _selectRole(BuildContext context, String role) async {
    await RoleService.switchRole(role);

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      /// User not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
      );
    } else {
      /// User already logged in
      if (role == "consumer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ConsumerHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        /// Background Gradient
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
                  /// LOGO
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/images/app_logo.png",
                        width: 150,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Choose Your Role",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "How do you want to use VoltShare?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                  ),

                  const SizedBox(height: 45),

                  /// CONSUMER
                  _roleButton(
                    icon: Icons.directions_car,
                    label: "Find EV / Charger",
                    gradient: const [Color(0xFF6C63FF), Color(0xFF4F46E5)],
                    onTap: () => _selectRole(context, "consumer"),
                  ),

                  const SizedBox(height: 18),

                  /// PROVIDER
                  _roleButton(
                    icon: Icons.ev_station,
                    label: "Provide EV / Charger",
                    gradient: const [Color(0xFF2ECC71), Color(0xFF27AE60)],
                    onTap: () => _selectRole(context, "provider"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,

      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Container(
          width: double.infinity,
          height: 60,
          alignment: Alignment.center,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),

              Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
