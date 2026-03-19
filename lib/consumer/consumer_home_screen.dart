import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

import 'find_charger/charger_list_screen.dart';
import 'find_ev/ev_list_screen.dart';

import '../map/map_screen.dart';
import '../profile/profile_screen.dart';
import '../booking/booking_history_screen.dart';
import '../payment/payment_history_screen.dart';

class ConsumerHomeScreen extends StatefulWidget {
  const ConsumerHomeScreen({super.key});

  @override
  State<ConsumerHomeScreen> createState() => _ConsumerHomeScreenState();
}

class _ConsumerHomeScreenState extends State<ConsumerHomeScreen> {
  UserModel? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final profile = await AuthService.getCurrentUserProfile();

      if (!mounted) return;

      setState(() {
        user = profile;
        loading = false;
      });
    } catch (e) {
      debugPrint("User load error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                /// HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 26),

                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF5E8DAA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// APP TITLE + USER
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "VoltShare",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Hi, ${user?.name ?? "User"} 👋",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      /// PROFILE ICON
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: user?.photoUrl != null
                              ? NetworkImage(user!.photoUrl!)
                              : null,
                          child: user?.photoUrl == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),

                /// BODY
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          /// FIND CHARGER
                          _actionCard(
                            icon: Icons.ev_station,
                            title: "Find Charger",
                            subtitle: "Nearby charging stations",
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
                            icon: Icons.electric_car,
                            title: "Find EV",
                            subtitle: "Rent electric vehicles",
                            color: AppColors.secondaryGreen,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EVListScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          /// MAP
                          _actionCard(
                            icon: Icons.map,
                            title: "Open Map",
                            subtitle: "View EVs & Chargers nearby",
                            color: Colors.indigo,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MapScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          /// BOOKING HISTORY
                          _actionCard(
                            icon: Icons.history,
                            title: "My Bookings",
                            subtitle: "View booking history",
                            color: Colors.orange,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const BookingHistoryScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          /// PAYMENT HISTORY
                          _actionCard(
                            icon: Icons.payment,
                            title: "Payment History",
                            subtitle: "View your payments",
                            color: Colors.teal,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PaymentHistoryScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  /// ACTION CARD
  Widget _actionCard({
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
        width: double.infinity,
        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 30, color: Colors.white),
            ),

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
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
