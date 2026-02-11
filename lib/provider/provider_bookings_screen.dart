import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class ProviderBookingsScreen extends StatelessWidget {
  const ProviderBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = BookingService.bookings
        .where((b) => b['status'] == 'pending')
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Incoming Requests')),
      body: bookings.isEmpty
          ? const Center(child: Text('No requests'))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (_, i) {
                final booking = bookings[i];
                return ListTile(
                  title: Text('${booking['type']} request'),
                  subtitle: Text('OTP: ${booking['otp']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      BookingService.acceptBooking(booking['id']);
                      Navigator.pop(context);
                    },
                    child: const Text('Accept'),
                  ),
                );
              },
            ),
    );
  }
}
