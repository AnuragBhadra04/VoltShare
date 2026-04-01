import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

import 'add_ev/add_ev_details_screen.dart';
import 'add_charger/add_charger_details_screen.dart';
import 'provider_bookings_screen.dart';
import 'provider_listing_screen.dart';
import '../payment/payment_history_screen.dart';
import '../profile/profile_screen.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
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
                /// ================= HEADER =================
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
                      /// TITLE + USER
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "VoltShare Provider",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Hi, ${user?.name ?? "Provider"} 👋",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      /// PROFILE
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

                /// ================= BODY =================
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),

                    child: Column(
                      children: [
                        /// ADD EV
                        _actionCard(
                          icon: Icons.electric_car,
                          title: "Add EV",
                          subtitle: "List vehicle (2W / 4W)",
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

                        const SizedBox(height: 20),

                        /// ADD CHARGER
                        _actionCard(
                          icon: Icons.ev_station,
                          title: "Add Charger",
                          subtitle: "Upload charging station",
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

                        /// BOOKINGS
                        _actionCard(
                          icon: Icons.list_alt,
                          title: "Booking Requests",
                          subtitle: "Accept / Reject / Manage",
                          color: Colors.indigo,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProviderBookingsScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        /// PAYMENTS
                        _actionCard(
                          icon: Icons.payments,
                          title: "Earnings",
                          subtitle: "View payment history",
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PaymentHistoryScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                        _actionCard(
                          icon: Icons.inventory,
                          title: "My Listings",
                          subtitle: "Edit / Delete your EVs & Chargers",
                          color: Colors.teal,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProviderListingsScreen(),
                              ),
                            );
                          },
                        ),

                        /// FUTURE (READY FOR YOU)
                        _actionCard(
                          icon: Icons.analytics,
                          title: "Analytics (Soon)",
                          subtitle: "Revenue & demand insights",
                          color: Colors.teal,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  /// ================= ACTION CARD =================
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
            colors: [color, color.withOpacity(.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Row(
          children: [
            /// ICON
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),

            const SizedBox(width: 18),

            /// TEXT
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
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
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
