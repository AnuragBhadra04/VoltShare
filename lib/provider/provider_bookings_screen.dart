import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';

class ProviderBookingsScreen extends StatefulWidget {
  const ProviderBookingsScreen({super.key});

  @override
  State<ProviderBookingsScreen> createState() => _ProviderBookingsScreenState();
}

class _ProviderBookingsScreenState extends State<ProviderBookingsScreen> {
  bool _loading = true;

  List<BookingModel> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  /// LOAD BOOKINGS FROM SUPABASE
  Future<void> _loadBookings() async {
    try {
      final response = await ApiService.supabase
          .from('bookings')
          .select()
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      setState(() {
        _bookings = (response as List)
            .map((json) => BookingModel.fromJson(json))
            .toList();

        _loading = false;
      });
    } catch (e) {
      debugPrint("ProviderBookingsScreen error: $e");

      setState(() {
        _loading = false;
      });
    }
  }

  /// ACCEPT BOOKING
  Future<void> _acceptBooking(String bookingId) async {
    try {
      await ApiService.supabase
          .from('bookings')
          .update({'status': 'accepted'})
          .eq('id', bookingId);

      _loadBookings();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Booking accepted")));
    } catch (e) {
      debugPrint("Accept booking error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Incoming Requests"),
        backgroundColor: AppColors.secondaryGreen,
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
          ? const Center(
              child: Text(
                "No incoming requests",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _bookings.length,

              itemBuilder: (_, i) {
                final booking = _bookings[i];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  child: ListTile(
                    leading: const Icon(Icons.book_online),

                    title: Text("${booking.itemType.toUpperCase()} Booking"),

                    subtitle: Text("Amount: ₹${booking.amount}"),

                    trailing: ElevatedButton(
                      onPressed: () {
                        _acceptBooking(booking.id!);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                      ),

                      child: const Text(
                        "Accept",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
