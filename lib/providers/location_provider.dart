import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  double? latitude;
  double? longitude;

  bool loading = false;
  String? error;

  /// =====================================================
  /// LOAD USER LOCATION
  /// =====================================================
  Future<void> loadLocation() async {
    if (loading) return;

    try {
      loading = true;
      error = null;

      notifyListeners();

      final Position location = await LocationService.getCurrentLocation();

      latitude = location.latitude;
      longitude = location.longitude;

      loading = false;

      notifyListeners();
    } catch (e) {
      loading = false;
      error = e.toString();

      notifyListeners();

      debugPrint("Location error: $e");
    }
  }

  /// =====================================================
  /// REFRESH LOCATION
  /// =====================================================
  Future<void> refreshLocation() async {
    await loadLocation();
  }

  /// =====================================================
  /// CLEAR LOCATION
  /// =====================================================
  void clearLocation() {
    latitude = null;
    longitude = null;

    notifyListeners();
  }

  /// =====================================================
  /// CHECK IF LOCATION EXISTS
  /// =====================================================
  bool get hasLocation => latitude != null && longitude != null;

  /// =====================================================
  /// RETURN POSITION OBJECT
  /// =====================================================
  Position? get position {
    if (!hasLocation) return null;

    return Position(
      latitude: latitude!,
      longitude: longitude!,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }
}
