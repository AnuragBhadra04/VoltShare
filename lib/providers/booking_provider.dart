import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';

class BookingProvider extends ChangeNotifier {
  List<BookingModel> _bookings = [];

  bool _loading = false;

  List<BookingModel> get bookings => _bookings;

  bool get loading => _loading;

  Future<void> fetchUserBookings(String userId) async {
    try {
      _loading = true;
      notifyListeners();

      // ✅ FIX: explicitly type the response
      final List<Map<String, dynamic>> data = await ApiService.getUserBookings(
        userId,
      );

      // ✅ FIX: safe conversion
      _bookings = data
          .map<BookingModel>((json) => BookingModel.fromJson(json))
          .toList();

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();

      debugPrint("BookingProvider error: $e");
    }
  }

  void clear() {
    _bookings.clear();
    notifyListeners();
  }
}
