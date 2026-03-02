import 'package:flutter/material.dart';
import '../payment/payment_screen.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../core/constants/colors.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> ev;

  const BookingScreen({super.key, required this.ev});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _loading = false;

  Future<void> _createBookingAndPay() async {
    setState(() => _loading = true);

    try {
      final user = AuthService.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final double amount =
          (widget.ev['pricePerHour'] ?? widget.ev['price'] ?? 0).toDouble();

      // ✅ INSERT BOOKING INTO SUPABASE
      final response = await ApiService.supabase
          .from('bookings')
          .insert({
            'user_id': user.id,
            'item_id': widget.ev['id'],
            'item_type': 'ev',
            'amount': amount,
            'status': 'pending',
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final String bookingId = response['id'].toString();

      if (!mounted) return;

      // ✅ NAVIGATE TO PAYMENT
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentScreen(amount: amount, bookingId: bookingId),
        ),
      );
    } catch (e) {
      debugPrint("Booking error: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Booking failed: $e")));
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final amount = (widget.ev['pricePerHour'] ?? widget.ev['price'] ?? 0)
        .toDouble();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Confirm Booking"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              widget.ev['name'] ??
                  "${widget.ev['brand']} ${widget.ev['model']}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("₹$amount per hour", style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: _loading ? null : _createBookingAndPay,

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Proceed to Payment",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
