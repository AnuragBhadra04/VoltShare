import 'package:geolocator/geolocator.dart';

class LocationService {
  /// ===============================
  /// CHECK LOCATION PERMISSION
  /// ===============================
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
        "Location permission permanently denied. Enable it in settings.",
      );
    }

    return permission;
  }

  /// ===============================
  /// GET CURRENT LOCATION
  /// ===============================
  static Future<Position> getCurrentLocation() async {
    await _handlePermission();

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// ===============================
  /// GET LAST KNOWN LOCATION
  /// (faster but may be outdated)
  /// ===============================
  static Future<Position?> getLastKnownLocation() async {
    await _handlePermission();

    return await Geolocator.getLastKnownPosition();
  }

  /// ===============================
  /// REAL TIME LOCATION STREAM
  /// Useful for live map tracking
  /// ===============================
  static Stream<Position> getLocationStream() async* {
    await _handlePermission();

    yield* Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  /// ===============================
  /// OPEN DEVICE LOCATION SETTINGS
  /// ===============================
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// ===============================
  /// DISTANCE BETWEEN TWO POINTS
  /// (returns meters)
  /// ===============================
  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
