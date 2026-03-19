import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../core/constants/colors.dart';
import 'ride_session_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  final String bookingId;

  const PinVerificationScreen({super.key, required this.bookingId});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController pinController = TextEditingController();
  bool loading = false;

  Future<void> verifyPin() async {
    setState(() => loading = true);

    try {
      final booking = await ApiService.supabase
          .from("bookings")
          .select()
          .eq("id", widget.bookingId)
          .single();

      final dbPin = booking["start_pin"].toString();

      if (pinController.text.trim() == dbPin) {
        /// Start ride
        await ApiService.updateBookingStatus(widget.bookingId, "active");

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RideSessionScreen(bookingId: widget.bookingId),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid PIN")));
      }
    } catch (e) {
      debugPrint("PIN verify error: $e");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Enter Ride PIN"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text(
              "Enter the 4-digit PIN provided by the owner",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,

              decoration: const InputDecoration(labelText: "Ride PIN"),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: loading ? null : verifyPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Start Ride"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
