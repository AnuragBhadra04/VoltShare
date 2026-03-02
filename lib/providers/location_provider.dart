import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  double? latitude;
  double? longitude;

  bool loading = false;
  String? error;

  /// 🔥 Load user location safely
  Future<void> loadLocation() async {
    try {
      loading = true;
      error = null;

      notifyListeners();

      final location = await LocationService.getCurrentLocation();

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

  /// 🔥 Check if location exists
  bool get hasLocation => latitude != null && longitude != null;
}
