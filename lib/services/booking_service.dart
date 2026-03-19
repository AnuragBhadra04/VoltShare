import 'dart:math';
import 'api_service.dart';

class BookingService {
  static final supabase = ApiService.supabase;

  /// Create new booking
  static Future<void> createBooking({
    required String userId,
    required String providerId,
    required String itemId,
    required String itemType,
    required double amount,
  }) async {
    await supabase.from("bookings").insert({
      "user_id": userId,
      "provider_id": providerId,
      "item_id": itemId,
      "item_type": itemType,
      "amount": amount,
      "status": "pending",
    });
  }

  /// Get consumer bookings
  static Future<List> getUserBookings(String userId) async {
    final data = await supabase
        .from("bookings")
        .select()
        .eq("user_id", userId)
        .order("created_at", ascending: false);

    return data;
  }

  /// Get provider bookings
  static Future<List> getProviderBookings(String providerId) async {
    final data = await supabase
        .from("bookings")
        .select()
        .eq("provider_id", providerId)
        .order("created_at", ascending: false);

    return data;
  }

  /// Accept booking
  static Future<void> acceptBooking(String bookingId) async {
    final pin = _generatePin();

    await supabase
        .from("bookings")
        .update({"status": "accepted", "start_pin": pin})
        .eq("id", bookingId);
  }

  /// Reject booking
  static Future<void> rejectBooking(String bookingId) async {
    await supabase
        .from("bookings")
        .update({"status": "rejected"})
        .eq("id", bookingId);
  }

  /// Start ride
  static Future<void> startRide(String bookingId) async {
    await supabase
        .from("bookings")
        .update({"ride_started": true, "status": "active"})
        .eq("id", bookingId);
  }

  /// End ride
  static Future<void> endRide(String bookingId) async {
    await supabase
        .from("bookings")
        .update({"ride_completed": true, "status": "completed"})
        .eq("id", bookingId);
  }

  /// Generate 4 digit PIN
  static int _generatePin() {
    final random = Random();
    return 1000 + random.nextInt(9000);
  }
}
