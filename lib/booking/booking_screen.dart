import 'package:flutter/material.dart';
import '../payment/payment_screen.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../core/constants/colors.dart';
import '../consumer/kyc_screen.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> ev;

  const BookingScreen({super.key, required this.ev});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool loading = false;
  bool acceptedTerms = false;

  final supabase = ApiService.supabase;

  Future<void> createBookingAndPay() async {
    try {
      final user = AuthService.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      /// ============================================
      /// ✅ TERMS CHECK
      /// ============================================
      if (!acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please accept Terms & Conditions")),
        );
        return;
      }

      setState(() => loading = true);

      /// ============================================
      /// ✅ KYC CHECK (DL + AADHAR)
      /// ============================================
      final userData = await supabase
          .from("users")
          .select()
          .eq("id", user.id)
          .single();

      if (userData["kyc_verified"] != true) {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KYCScreen()),
        );

        setState(() => loading = false);
        return;
      }

      /// ============================================
      /// PRICE
      /// ============================================
      final double amount =
          (widget.ev['pricePerHour'] ??
                  widget.ev['price_per_hour'] ??
                  widget.ev['price'] ??
                  0)
              .toDouble();

      final String itemType = widget.ev['type'] ?? "ev";

      final String providerId =
          widget.ev['provider_id'] ?? widget.ev['providerId'] ?? "";

      if (providerId.isEmpty) {
        throw Exception("Provider not found");
      }

      /// ============================================
      /// CREATE BOOKING
      /// ============================================
      final response = await supabase
          .from('bookings')
          .insert({
            'user_id': user.id,
            'provider_id': providerId,
            'item_id': widget.ev['id'],
            'item_type': itemType,
            'amount': amount,
            'status': 'pending',
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final String bookingId = response['id'].toString();

      if (!mounted) return;

      /// ============================================
      /// NAVIGATE TO PAYMENT
      /// ============================================
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

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final amount =
        (widget.ev['pricePerHour'] ??
                widget.ev['price_per_hour'] ??
                widget.ev['price'] ??
                0)
            .toDouble();

    final name =
        widget.ev['name'] ??
        "${widget.ev['brand'] ?? ""} ${widget.ev['model'] ?? ""}";

    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          /// ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF5E8DAA)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Confirm Booking",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Review your booking details",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /// ================= BODY =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// BOOKING CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.electric_car,
                                color: AppColors.primaryPurple,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Price", style: TextStyle(fontSize: 16)),

                            Text(
                              "₹$amount",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ✅ TERMS & CONDITIONS
                  Row(
                    children: [
                      Checkbox(
                        value: acceptedTerms,
                        onChanged: (v) {
                          setState(() => acceptedTerms = v!);
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "I accept Terms & Conditions",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// PAY BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: loading ? null : createBookingAndPay,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Proceed to Payment",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
