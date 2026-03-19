import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../core/constants/colors.dart';
import 'pin_verification_screen.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  List bookings = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      final user = AuthService.currentUser;

      if (user == null) return;

      final data = await ApiService.getUserBookings(user.id);

      if (!mounted) return;

      setState(() {
        bookings = data;
        loading = false;
      });
    } catch (e) {
      debugPrint("Booking history error: $e");

      setState(() => loading = false);
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "accepted":
        return Colors.green;

      case "pending":
        return Colors.orange;

      case "active":
        return Colors.blue;

      case "completed":
        return Colors.grey;

      case "rejected":
        return Colors.red;

      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
          ? const Center(child: Text("No bookings yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (_, i) {
                final booking = bookings[i];

                final id = booking["id"];
                final amount = booking["amount"];
                final status = booking["status"];
                final type = booking["item_type"];
                final created = booking["created_at"];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Booking #${id.toString().substring(0, 6)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),

                              decoration: BoxDecoration(
                                color: statusColor(status),
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text("Type: $type"),

                        const SizedBox(height: 6),

                        Text("Amount: ₹$amount"),

                        const SizedBox(height: 6),

                        Text(
                          "Date: $created",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (status == "accepted")
                          SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondaryGreen,
                              ),

                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PinVerificationScreen(bookingId: id),
                                  ),
                                );
                              },

                              child: const Text(
                                "Start Ride",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
