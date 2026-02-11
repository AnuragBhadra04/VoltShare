class BookingService {
  static final List<Map<String, dynamic>> bookings = [];

  // CREATE BOOKING
  static Future<void> createBooking({
    required String type, // 'ev' or 'charger'
    required Map<String, dynamic> item,
  }) async {
    bookings.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'item': item,
      'status': 'pending', // pending / accepted / started / completed
      'otp': _generateOTP(),
    });
  }

  // PROVIDER ACCEPT
  static void acceptBooking(String id) {
    final booking = bookings.firstWhere((b) => b['id'] == id);
    booking['status'] = 'accepted';
  }

  // VERIFY OTP
  static bool verifyOTP(String id, String otp) {
    final booking = bookings.firstWhere((b) => b['id'] == id);
    return booking['otp'] == otp;
  }

  // START SERVICE
  static void startService(String id) {
    final booking = bookings.firstWhere((b) => b['id'] == id);
    booking['status'] = 'started';
  }

  // COMPLETE SERVICE
  static void completeService(String id) {
    final booking = bookings.firstWhere((b) => b['id'] == id);
    booking['status'] = 'completed';
  }

  static String _generateOTP() {
    return (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();
  }
}
