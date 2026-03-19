import 'package:flutter/material.dart';
import '../models/charger_model.dart';
import '../services/api_service.dart';

class ChargerProvider extends ChangeNotifier {
  List<ChargerModel> _chargers = [];

  bool _loading = false;
  String? _error;

  List<ChargerModel> get chargers => _chargers;
  bool get loading => _loading;
  String? get error => _error;

  // =====================================================
  // FETCH NEARBY CHARGERS
  // =====================================================
  Future<void> fetchNearbyChargers(double lat, double lng) async {
    if (_loading) return;

    try {
      _loading = true;
      _error = null;

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
      _error = e.toString();

      notifyListeners();

      debugPrint("ChargerProvider error: $e");
    }
  }

  // =====================================================
  // REFRESH CHARGERS
  // =====================================================
  Future<void> refresh(double lat, double lng) async {
    await fetchNearbyChargers(lat, lng);
  }

  // =====================================================
  // ADD CHARGER
  // =====================================================
  Future<void> addCharger(ChargerModel charger) async {
    try {
      await ApiService.addCharger(charger.toJson());

      _chargers = [..._chargers, charger];

      notifyListeners();
    } catch (e) {
      debugPrint("Add charger error: $e");
    }
  }

  // =====================================================
  // GET CHARGER BY ID
  // =====================================================
  ChargerModel? getChargerById(String id) {
    try {
      return _chargers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // =====================================================
  // CLEAR CACHE
  // =====================================================
  void clear() {
    _chargers = [];
    notifyListeners();
  }
}
