import 'package:flutter/material.dart';
import '../models/ev_model.dart';
import '../services/api_service.dart';

class EVProvider extends ChangeNotifier {
  List<EVModel> _evs = [];
  bool _loading = false;

  List<EVModel> get evs => _evs;
  bool get loading => _loading;

  // ✅ Fetch nearby EVs from Supabase
  Future<void> fetchNearbyEVs(double lat, double lng) async {
    try {
      _loading = true;
      notifyListeners();

      final List<EVModel> data = await ApiService.getNearbyEVs(lat, lng);

      _evs = data;

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();
      debugPrint("EVProvider error: $e");
    }
  }

  // ✅ Add EV to Supabase
  Future<void> addEV(EVModel ev) async {
    try {
      await ApiService.addEV(ev.toJson());

      _evs.add(ev);

      notifyListeners();
    } catch (e) {
      debugPrint("Add EV error: $e");
    }
  }

  // ✅ Clear cache
  void clear() {
    _evs.clear();
    notifyListeners();
  }
}
