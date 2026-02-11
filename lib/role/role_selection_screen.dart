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
                const Text(
                  'Choose Your Role',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleText,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'How do you want to use VoltShare?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.subtitleText),
                ),
                const SizedBox(height: 40),

                _roleButton(
                  icon: Icons.flash_on,
                  label: 'Service Taker',
                  color: AppColors.primaryPurple,
                  onTap: () => _selectRole(context, 'taker'),
                ),

                const SizedBox(height: 16),

                _roleButton(
                  icon: Icons.handyman,
                  label: 'Service Provider',
                  color: AppColors.secondaryGreen,
                  onTap: () => _selectRole(context, 'provider'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
