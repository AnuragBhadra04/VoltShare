import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../services/api_service.dart';
import '../services/booking_realtime_service.dart';

class ProviderBookingsScreen extends StatefulWidget {
  const ProviderBookingsScreen({super.key});

  @override
  State<ProviderBookingsScreen> createState() => _ProviderBookingsScreenState();
}

class _ProviderBookingsScreenState extends State<ProviderBookingsScreen> {
  List bookings = [];
  bool loading = true;
  bool updating = false;

  final supabase = ApiService.supabase;

  @override
  void initState() {
    super.initState();
    _loadBookings();

    final providerId = supabase.auth.currentUser!.id;

    BookingRealtimeService.listenForBookings(
      providerId: providerId,
      onNewBooking: (booking) {
        _loadBookings();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New booking request received")),
        );
      },
    );
  }

  @override
  void dispose() {
    BookingRealtimeService.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    try {
      final providerId = supabase.auth.currentUser!.id;

      final data = await supabase
          .from("bookings")
          .select()
          .eq("provider_id", providerId)
          .order("created_at", ascending: false);

      if (!mounted) return;

      setState(() {
        bookings = data;
        loading = false;
      });
    } catch (e) {
      debugPrint("Booking load error: $e");

      if (!mounted) return;

      setState(() => loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load bookings")));
    }
  }

  /// Generate 4 digit ride PIN
  int _generatePin() {
    final random = Random();
    return 1000 + random.nextInt(9000);
  }

  /// Accept booking
  Future<void> _acceptBooking(String bookingId) async {
    try {
      setState(() => updating = true);

      final pin = _generatePin();

      await supabase
          .from("bookings")
          .update({"status": "accepted", "start_pin": pin})
          .eq("id", bookingId);

      await _loadBookings();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking accepted • PIN $pin generated")),
      );
    } catch (e) {
      debugPrint("Accept booking error: $e");
    }

    if (mounted) setState(() => updating = false);
  }

  /// Reject booking
  Future<void> _rejectBooking(String bookingId) async {
    try {
      setState(() => updating = true);

      await supabase
          .from("bookings")
          .update({"status": "rejected"})
          .eq("id", bookingId);

      await _loadBookings();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Booking rejected")));
    } catch (e) {
      debugPrint("Reject booking error: $e");
    }

    if (mounted) setState(() => updating = false);
  }

  Color _statusColor(String? status) {
    switch (status) {
      case "accepted":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "active":
        return Colors.blue;
      case "completed":
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Provider Bookings"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
          ? const Center(
              child: Text("No bookings yet", style: TextStyle(fontSize: 16)),
            )
          : RefreshIndicator(
              onRefresh: _loadBookings,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (_, i) {
                  final booking = bookings[i];

                  final id = booking["id"]?.toString() ?? "";
                  final amount = booking["amount"] ?? 0;
                  final status = booking["status"]?.toString();
                  final itemType = booking["item_type"] ?? "Unknown";
                  final createdAt = booking["created_at"] ?? "";
                  final pin = booking["start_pin"];

                  final shortId = id.length > 6 ? id.substring(0, 6) : id;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// HEADER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Booking #$shortId",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(status),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  status ?? "pending",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Type: $itemType",
                            style: const TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Amount: ₹$amount",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Date: $createdAt",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// PIN AFTER ACCEPT
                          if (status == "accepted" && pin != null)
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Ride PIN: $pin",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),

                          /// ACTION BUTTONS
                          if (status == "pending")
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: updating
                                        ? null
                                        : () => _acceptBooking(id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text(
                                      "Accept",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: updating
                                        ? null
                                        : () => _rejectBooking(id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text(
                                      "Reject",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
