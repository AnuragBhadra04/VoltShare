import 'package:geolocator/geolocator.dart';

class LocationService {
  /// =====================================================
  /// CHECK & REQUEST PERMISSION
  /// =====================================================
  static Future<LocationPermission> _handlePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location services are disabled. Please enable GPS.");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();

      throw Exception(
        "Location permission permanently denied. Enable from settings.",
      );
    }

    return permission;
  }

  /// =====================================================
  /// GET CURRENT LOCATION
  /// =====================================================
  static Future<Position> getCurrentLocation() async {
    await _handlePermission();

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 15),
      );
    } catch (e) {
      throw Exception("Failed to get location: $e");
    }
  }

  /// =====================================================
  /// GET LAST KNOWN LOCATION (FASTER)
  /// =====================================================
  static Future<Position?> getLastKnownLocation() async {
    await _handlePermission();

    return await Geolocator.getLastKnownPosition();
  }

  /// =====================================================
  /// OPEN LOCATION SETTINGS
  /// =====================================================
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
