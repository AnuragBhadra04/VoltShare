import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/constants/colors.dart';
import '../services/api_service.dart';
import '../rating/rating_screen.dart';
import 'active_ride_screen.dart';

class BookingSuccessScreen extends StatefulWidget {
  final String bookingId;

  const BookingSuccessScreen({super.key, required this.bookingId});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  String status = "pending";

  late RealtimeChannel channel;

  @override
  void initState() {
    super.initState();
    _listenRealtime();
  }

  /// ============================
  /// ✅ REALTIME LISTENER (FINAL FIX)
  /// ============================
  void _listenRealtime() {
    channel = ApiService.supabase
        .channel('booking_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'bookings',

          /// ✅ IMPORTANT FIX
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: widget.bookingId,
          ),

          callback: (payload) {
            final data = payload.newRecord;

            if (data == null) return;

            final newStatus = data['status'];

            debugPrint("Realtime Status: $newStatus");

            setState(() => status = newStatus);

            /// ✅ ACCEPTED
            if (newStatus == "accepted") {
              _showSnack("Provider Accepted ✅");
            }

            /// ❌ REJECTED
            if (newStatus == "rejected") {
              _showSnack("Booking Rejected ❌");
            }

            /// 🚀 ACTIVE → RIDE SCREEN
            if (newStatus == "active") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ActiveRideScreen(bookingId: widget.bookingId),
                ),
              );
            }

            /// 🎉 COMPLETED → RATING
            if (newStatus == "completed") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => RatingScreen(bookingId: widget.bookingId),
                ),
              );
            }
          },
        )
        .subscribe();
  }

  /// ============================
  /// SNACKBAR
  /// ============================
  void _showSnack(String msg) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    ApiService.supabase.removeChannel(channel);
    super.dispose();
  }

  /// ============================
  /// UI
  /// ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
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
                  "Booking Created",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Waiting for provider confirmation...",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// ICON
                  Icon(
                    status == "accepted"
                        ? Icons.check_circle
                        : status == "rejected"
                        ? Icons.cancel
                        : Icons.timelapse,
                    size: 80,
                    color: status == "accepted"
                        ? Colors.green
                        : status == "rejected"
                        ? Colors.red
                        : Colors.orange,
                  ),

                  const SizedBox(height: 20),

                  /// STATUS TEXT
                  Text(
                    "Status: $status",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: status == "accepted"
                          ? Colors.green
                          : status == "rejected"
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Please wait while provider responds",
                    style: TextStyle(color: Colors.black54),
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
