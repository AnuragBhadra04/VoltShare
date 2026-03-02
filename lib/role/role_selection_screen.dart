import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../services/role_service.dart';
import '../auth/auth_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _selectRole(BuildContext context, String role) async {
    await RoleService.saveRole(role);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
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
                // 🔥 LOGO
                Hero(
                  tag: "app_logo",
                  child: Image.asset(
                    'assets/images/app_logo2.png',
                    height: 280,
                  ),
                ),

                const SizedBox(height: 20),

                // TITLE
                const Text(
                  'Choose Your Role',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleText,
                  ),
                ),

                const SizedBox(height: 8),

                // SUBTITLE
                const Text(
                  'How do you want to use VoltShare?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.subtitleText, fontSize: 15),
                ),

                const SizedBox(height: 40),

                // SERVICE TAKER BUTTON (VIOLET)
                _premiumRoleButton(
                  icon: Icons.flash_on,
                  label: 'Service Taker',
                  gradient: const [Color(0xFF6C4DFF), Color(0xFF5A3FE0)],
                  onTap: () => _selectRole(context, 'taker'),
                ),

                const SizedBox(height: 18),

                // SERVICE PROVIDER BUTTON (GREEN)
                _premiumRoleButton(
                  icon: Icons.handyman,
                  label: 'Service Provider',
                  gradient: const [Color(0xFF00C853), Color(0xFF00A844)],
                  onTap: () => _selectRole(context, 'provider'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _premiumRoleButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.45),
              blurRadius: 22,
              offset: const Offset(0, 12),
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
