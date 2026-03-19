import 'package:supabase_flutter/supabase_flutter.dart';

class BookingRealtimeService {
  static final supabase = Supabase.instance.client;

  static RealtimeChannel? _channel;

  static void listenForBookings({
    required String providerId,
    required Function(Map<String, dynamic>) onNewBooking,
  }) {
    _channel = supabase.channel("booking_updates");

    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: "public",
          table: "bookings",
          callback: (payload) {
            final newBooking = payload.newRecord;

            if (newBooking["provider_id"] == providerId) {
              onNewBooking(newBooking);
            }
          },
        )
        .subscribe();
  }

  static void dispose() {
    if (_channel != null) {
      supabase.removeChannel(_channel!);
      _channel = null;
    }
  }
}
