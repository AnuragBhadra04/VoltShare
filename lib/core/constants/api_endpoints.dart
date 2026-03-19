class ApiEndpoints {
  /// =========================
  /// Supabase Tables
  /// =========================

  static const String users = "users";
  static const String evs = "evs";
  static const String chargers = "chargers";
  static const String bookings = "bookings";
  static const String ratings = "ratings";

  /// =========================
  /// Storage Buckets
  /// =========================

  static const String profileImages = "profile-images";
  static const String chargerImages = "charger-images";
  static const String evImages = "ev-images";

  /// =========================
  /// Booking Status
  /// =========================

  static const String bookingPending = "pending";
  static const String bookingConfirmed = "confirmed";
  static const String bookingCompleted = "completed";
  static const String bookingCancelled = "cancelled";

  /// =========================
  /// Supabase Edge Functions
  /// (future integrations)
  /// =========================

  static const String paymentWebhook = "payment-webhook";
  static const String bookingNotification = "booking-notification";

  /// =========================
  /// RPC Functions (Future)
  /// =========================

  static const String nearbyChargers = "nearby_chargers";
  static const String nearbyEvs = "nearby_evs";
}
