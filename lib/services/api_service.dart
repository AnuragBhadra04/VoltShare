import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ev_model.dart';
import '../models/charger_model.dart';
import '../models/booking_model.dart';
import 'dart:math';

class ApiService {
  static final SupabaseClient supabase = Supabase.instance.client;

  // =====================================================
  // EV APIs
  // =====================================================

  static Future<List<EVModel>> getNearbyEVs(
    double userLat,
    double userLng, {
    double radiusKm = 10,
  }) async {
    final response = await supabase
        .from('evs')
        .select()
        .eq('is_available', true);

    final List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(
      response,
    );

    final nearby = list.where((ev) {
      final lat = (ev['latitude'] ?? 0).toDouble();
      final lng = (ev['longitude'] ?? 0).toDouble();

      final distance = _calculateDistance(userLat, userLng, lat, lng);

      return distance <= radiusKm;
    }).toList();

    return nearby.map((e) => EVModel.fromJson(e)).toList();
  }

  static Future<void> addEV(Map<String, dynamic> evData) async {
    await supabase.from('evs').insert(evData);
  }

  // =====================================================
  // CHARGER APIs
  // =====================================================

  static Future<List<ChargerModel>> getNearbyChargers(
    double userLat,
    double userLng, {
    double radiusKm = 10,
  }) async {
    final response = await supabase
        .from('chargers')
        .select()
        .eq('is_available', true);

    final List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(
      response,
    );

    final nearby = list.where((charger) {
      final lat = (charger['latitude'] ?? 0).toDouble();
      final lng = (charger['longitude'] ?? 0).toDouble();

      final distance = _calculateDistance(userLat, userLng, lat, lng);

      return distance <= radiusKm;
    }).toList();

    return nearby.map((e) => ChargerModel.fromJson(e)).toList();
  }

  static Future<void> addCharger(Map<String, dynamic> chargerData) async {
    await supabase.from('chargers').insert(chargerData);
  }

  // =====================================================
  // BOOKING APIs
  // =====================================================

  /// CREATE booking and RETURN booking model
  static Future<BookingModel> createBooking(
    Map<String, dynamic> bookingData,
  ) async {
    final response = await supabase
        .from('bookings')
        .insert(bookingData)
        .select()
        .single();

    return BookingModel.fromJson(response);
  }

  /// UPDATE booking status
  static Future<void> updateBookingStatus(
    String bookingId,
    String status,
  ) async {
    await supabase
        .from('bookings')
        .update({'status': status})
        .eq('id', bookingId);
  }

  // =====================================================
  // GET user bookings
  // =====================================================
  static Future<List<Map<String, dynamic>>> getUserBookings(
    String userId,
  ) async {
    try {
      final response = await supabase
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      // ✅ FIX: proper casting
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception("Failed to fetch bookings: $e");
    }
  }

  // =====================================================
  // DISTANCE CALCULATION
  // =====================================================

  static double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const R = 6371;

    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  static double _toRad(double degree) {
    return degree * pi / 180;
  }
}
