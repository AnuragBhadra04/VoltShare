import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import 'add_charger/add_charger_details_screen.dart';
import 'add_ev/add_ev_details_screen.dart';

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryGreen,
        elevation: 0,
        title: const Text(
          'Provider Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Manage your services',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add chargers or EVs and earn from nearby users',
                  style: TextStyle(fontSize: 15, color: AppColors.subtitleText),
                ),

                const SizedBox(height: 32),

                // ➕ ADD CHARGER
                _actionCard(
                  context,
                  icon: Icons.ev_station,
                  title: 'Add Charger',
                  subtitle: 'List your charging station',
                  color: AppColors.primaryPurple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddChargerDetailsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // ➕ ADD EV
                _actionCard(
                  context,
                  icon: Icons.electric_car,
                  title: 'Add EV',
                  subtitle: 'Rent out your electric vehicle',
                  color: AppColors.secondaryGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddEVDetailsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // 📊 Earnings placeholder
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 32,
                        color: AppColors.secondaryGreen,
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Total Earnings: ₹0',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 Reusable card
  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 42, color: Colors.white),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
