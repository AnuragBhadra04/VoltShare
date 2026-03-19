import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';

class BookingProvider extends ChangeNotifier {
  List<BookingModel> _bookings = [];

  bool _loading = false;
  String? _error;

  List<BookingModel> get bookings => _bookings;
  bool get loading => _loading;
  String? get error => _error;

  // =====================================================
  // FETCH USER BOOKINGS
  // =====================================================
  Future<void> fetchUserBookings(String userId) async {
    if (_loading) return;

    try {
      _loading = true;
      _error = null;

      notifyListeners();

      final List<Map<String, dynamic>> data = await ApiService.getUserBookings(
        userId,
      );

      _bookings = data
          .map<BookingModel>((json) => BookingModel.fromJson(json))
          .toList();

      _loading = false;

      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();

      notifyListeners();

      debugPrint("BookingProvider error: $e");
    }
  }

  // =====================================================
  // CREATE BOOKING
  // =====================================================
  Future<BookingModel?> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final booking = await ApiService.createBooking(bookingData);

      _bookings = [booking, ..._bookings];

      notifyListeners();

      return booking;
    } catch (e) {
      debugPrint("Create booking error: $e");

      return null;
    }
  }

  // =====================================================
  // REFRESH BOOKINGS
  // =====================================================
  Future<void> refresh(String userId) async {
    await fetchUserBookings(userId);
  }

  // =====================================================
  // GET BOOKING BY ID
  // =====================================================
  BookingModel? getBookingById(String id) {
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  // =====================================================
  // CLEAR CACHE
  // =====================================================
  void clear() {
    _bookings = [];
    notifyListeners();
  }
}
