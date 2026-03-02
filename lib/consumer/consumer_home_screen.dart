import 'package:flutter/material.dart';

import '../core/constants/colors.dart';

import 'find_charger/charger_list_screen.dart';
import 'find_ev/ev_list_screen.dart';

import '../map/map_screen.dart';

class ConsumerHomeScreen extends StatelessWidget {
  const ConsumerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('VoltShare'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                /// FIND CHARGER
                _actionCard(
                  context,
                  icon: Icons.ev_station,
                  title: 'Find Charger',
                  subtitle: 'Nearby charging stations',
                  color: AppColors.primaryPurple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChargerListScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                /// FIND EV
                _actionCard(
                  context,
                  icon: Icons.electric_car,
                  title: 'Find EV',
                  subtitle: 'Rent electric vehicles',
                  color: AppColors.secondaryGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EVListScreen()),
                    );
                  },
                ),

                const SizedBox(height: 24),

                /// OPEN MAP
                _actionCard(
                  context,
                  icon: Icons.map,
                  title: 'Open Map',
                  subtitle: 'View nearby EV & Chargers',
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MapScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),

        child: Row(
          children: [
            Icon(icon, size: 44, color: Colors.white),

            const SizedBox(width: 20),

            Column(
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

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
