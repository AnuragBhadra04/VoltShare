import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class BookingOTPScreen extends StatelessWidget {
  final String bookingId;
  const BookingOTPScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter OTP'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final ok = BookingService.verifyOTP(bookingId, controller.text);

                if (ok) {
                  BookingService.startService(bookingId);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Invalid OTP')));
                }
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
