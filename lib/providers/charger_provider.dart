import 'package:flutter/material.dart';
import '../models/charger_model.dart';
import '../services/api_service.dart';

class ChargerProvider extends ChangeNotifier {
  List<ChargerModel> _chargers = [];
  bool _loading = false;

  List<ChargerModel> get chargers => _chargers;
  bool get loading => _loading;

  /// ✅ Fetch chargers from Supabase
  Future<void> fetchNearbyChargers(double lat, double lng) async {
    try {
      _loading = true;
      notifyListeners();

      final List<ChargerModel> data = await ApiService.getNearbyChargers(
        lat,
        lng,
      );

      _chargers = data;

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();

      debugPrint("ChargerProvider error: $e");
    }
  }

  /// ✅ Add charger to Supabase
  Future<void> addCharger(ChargerModel charger) async {
    try {
      await ApiService.addCharger(charger.toJson());

      _chargers.add(charger);

      notifyListeners();
    } catch (e) {
      debugPrint("Add charger error: $e");
    }
  }

  /// ✅ Clear cache
  void clear() {
    _chargers.clear();

    notifyListeners();
  }
}
