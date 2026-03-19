import 'package:flutter/material.dart';
import '../models/ev_model.dart';
import '../services/api_service.dart';

class EVProvider extends ChangeNotifier {
  List<EVModel> _evs = [];

  bool _loading = false;
  String? _error;

  List<EVModel> get evs => _evs;
  bool get loading => _loading;
  String? get error => _error;

  // =====================================================
  // FETCH NEARBY EVs
  // =====================================================
  Future<void> fetchNearbyEVs(double lat, double lng) async {
    if (_loading) return;

    try {
      _loading = true;
      _error = null;

      notifyListeners();

      final List<EVModel> data = await ApiService.getNearbyEVs(lat, lng);

      _evs = data;

      _loading = false;

      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();

      notifyListeners();

      debugPrint("EVProvider error: $e");
    }
  }

  // =====================================================
  // REFRESH EV LIST
  // =====================================================
  Future<void> refresh(double lat, double lng) async {
    await fetchNearbyEVs(lat, lng);
  }

  // =====================================================
  // ADD EV
  // =====================================================
  Future<void> addEV(EVModel ev) async {
    try {
      await ApiService.addEV(ev.toJson());

      _evs = [..._evs, ev];

      notifyListeners();
    } catch (e) {
      debugPrint("Add EV error: $e");
    }
  }

  // =====================================================
  // GET EV BY ID
  // =====================================================
  EVModel? getEVById(String id) {
    try {
      return _evs.firstWhere((ev) => ev.id == id);
    } catch (_) {
      return null;
    }
  }

  // =====================================================
  // CLEAR CACHE
  // =====================================================
  void clear() {
    _evs = [];
    notifyListeners();
  }
}
