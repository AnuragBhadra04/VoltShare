import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

import 'find_charger/charger_list_screen.dart';
import 'find_ev/ev_list_screen.dart';

import '../map/map_screen.dart';
import '../profile/profile_screen.dart';
import '../booking/booking_history_screen.dart';
import '../payment/payment_history_screen.dart';
import '../consumer/kyc_screen.dart';

class ConsumerHomeScreen extends StatefulWidget {
  const ConsumerHomeScreen({super.key});

  @override
  State<ConsumerHomeScreen> createState() => _ConsumerHomeScreenState();
}

class _ConsumerHomeScreenState extends State<ConsumerHomeScreen> {
  UserModel? user;
  bool loading = true;

  String selectedType = "2_wheeler";

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

  /// ============================
  /// CHECK KYC BEFORE ACCESS
  /// ============================
  Future<bool> _checkKYC() async {
    final userId = ApiService.supabase.auth.currentUser!.id;

    final data = await ApiService.supabase
        .from("users")
        .select()
        .eq("id", userId)
        .single();

    if (data["kyc_verified"] == true) {
      return true;
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KYCScreen()),
      );
      return false;
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
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                        /// CATEGORY SELECT
                        DropdownButtonFormField(
                          value: selectedType,
                          items: const [
                            DropdownMenuItem(
                              value: "2_wheeler",
                              child: Text("2 Wheeler"),
                            ),
                            DropdownMenuItem(
                              value: "4_wheeler",
                              child: Text("4 Wheeler"),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => selectedType = v.toString()),
                          decoration: const InputDecoration(
                            labelText: "Select Vehicle Type",
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// FIND CHARGER
                        _actionCard(
                          icon: Icons.ev_station,
                          title: "Find Charger",
                          subtitle: "Nearby charging stations",
                          color: AppColors.primaryPurple,
                          onTap: () async {
                            if (!await _checkKYC()) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChargerListScreen(
                                  vehicleType: selectedType,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        /// FIND EV
                        _actionCard(
                          icon: Icons.electric_car,
                          title: "Find EV",
                          subtitle: "Rent vehicles",
                          color: AppColors.secondaryGreen,
                          onTap: () async {
                            if (!await _checkKYC()) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EVListScreen(vehicleType: selectedType),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        /// MAP
                        _actionCard(
                          icon: Icons.map,
                          title: "Open Map",
                          subtitle: "Nearby EV & chargers",
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

                        /// BOOKINGS
                        _actionCard(
                          icon: Icons.history,
                          title: "My Bookings",
                          subtitle: "Booking history",
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

                        /// PAYMENTS
                        _actionCard(
                          icon: Icons.payment,
                          title: "Payment History",
                          subtitle: "Your payments",
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
          gradient: LinearGradient(colors: [color, color.withOpacity(0.85)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
