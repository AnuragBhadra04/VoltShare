import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/ev_model.dart';
import '../models/charger_model.dart';
import '../models/booking_model.dart';
import '../core/constants/api_endpoints.dart';
import 'location_service.dart';

class ApiService {
  static final SupabaseClient supabase = Supabase.instance.client;

  // =====================================================
  // EV APIs
  // =====================================================

  static Future<List<EVModel>> getNearbyEVs(
    double userLat,
    double userLng, {
    double radiusKm = 2,
  }) async {
    try {
      final response = await supabase
          .from(ApiEndpoints.evs)
          .select()
          .eq('is_available', true);

      final list = List<Map<String, dynamic>>.from(response);

      final nearby = list.where((ev) {
        final lat = (ev['latitude'] ?? 0).toDouble();
        final lng = (ev['longitude'] ?? 0).toDouble();

        final distance = _calculateDistance(userLat, userLng, lat, lng);
        return distance <= radiusKm;
      }).toList();

      return nearby.map((e) => EVModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to fetch nearby EVs: $e");
    }
  }

  static Future<void> addEV(Map<String, dynamic> evData) async {
    try {
      final user = supabase.auth.currentUser;

      final location = await LocationService.getCurrentLocation();

      await supabase.from(ApiEndpoints.evs).insert({
        ...evData,
        "provider_id": user?.id,
        "latitude": location.latitude,
        "longitude": location.longitude,
        "created_at": DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception("Failed to add EV: $e");
    }
  }

  // =====================================================
  // CHARGER APIs
  // =====================================================

  static Future<List<ChargerModel>> getNearbyChargers(
    double userLat,
    double userLng, {
    double radiusKm = 2,
  }) async {
    try {
      final response = await supabase
          .from(ApiEndpoints.chargers)
          .select()
          .eq('is_available', true);

      final list = List<Map<String, dynamic>>.from(response);

      final nearby = list.where((charger) {
        final lat = (charger['latitude'] ?? 0).toDouble();
        final lng = (charger['longitude'] ?? 0).toDouble();

        final distance = _calculateDistance(userLat, userLng, lat, lng);
        return distance <= radiusKm;
      }).toList();

      return nearby.map((e) => ChargerModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to fetch nearby chargers: $e");
    }
  }

  static Future<void> addCharger(Map<String, dynamic> chargerData) async {
    try {
      final user = supabase.auth.currentUser;

      final location = await LocationService.getCurrentLocation();

      await supabase.from(ApiEndpoints.chargers).insert({
        ...chargerData,
        "provider_id": user?.id,
        "latitude": location.latitude,
        "longitude": location.longitude,
        "created_at": DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception("Failed to add charger: $e");
    }
  }

  // =====================================================
  // BOOKING APIs
  // =====================================================

  static Future<BookingModel> createBooking(
    Map<String, dynamic> bookingData,
  ) async {
    try {
      final response = await supabase
          .from(ApiEndpoints.bookings)
          .insert(bookingData)
          .select()
          .single();

      return BookingModel.fromJson(response);
    } catch (e) {
      throw Exception("Failed to create booking: $e");
    }
  }

  static Future<void> updateBookingStatus(
    String bookingId,
    String status,
  ) async {
    try {
      await supabase
          .from(ApiEndpoints.bookings)
          .update({"status": status})
          .eq("id", bookingId);
    } catch (e) {
      throw Exception("Failed to update booking: $e");
    }
  }

  // =====================================================
  // USER BOOKINGS
  // =====================================================

  static Future<List<Map<String, dynamic>>> getUserBookings(
    String userId,
  ) async {
    try {
      final response = await supabase
          .from(ApiEndpoints.bookings)
          .select()
          .eq("user_id", userId)
          .order("created_at", ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception("Failed to fetch bookings: $e");
    }
  }

  // =====================================================
  // DISTANCE CALCULATION (HAVERSINE)
  // =====================================================

  static double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadius = 6371;

    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRad(double degree) {
    return degree * pi / 180;
  }
}
