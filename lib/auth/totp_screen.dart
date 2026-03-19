import '../models/ev_model.dart';
import '../services/api_service.dart';

class EVRepository {
  /// ===============================
  /// GET NEARBY EVs
  /// ===============================
  Future<List<EVModel>> getNearbyEVs({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    try {
      final evs = await ApiService.getNearbyEVs(
        latitude,
        longitude,
        radiusKm: radiusKm,
      );

      return evs;
    } catch (e) {
      throw Exception("Failed to fetch EVs: $e");
    }
  }

  /// ===============================
  /// ADD EV
  /// ===============================
  Future<void> addEV(EVModel ev) async {
    try {
      await ApiService.addEV(ev.toJson());
    } catch (e) {
      throw Exception("Failed to add EV: $e");
    }
  }

  /// ===============================
  /// GET PROVIDER EVs
  /// ===============================
  Future<List<EVModel>> getProviderEVs(String providerId) async {
    try {
      final response = await ApiService.supabase
          .from('evs')
          .select()
          .eq('provider_id', providerId)
          .order('created_at', ascending: false);

      final list = List<Map<String, dynamic>>.from(response);

      return list.map((e) => EVModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to fetch provider EVs: $e");
    }
  }

  /// ===============================
  /// DELETE EV
  /// ===============================
  Future<void> deleteEV(String id) async {
    try {
      await ApiService.supabase.from('evs').delete().eq('id', id);
    } catch (e) {
      throw Exception("Failed to delete EV: $e");
    }
  }
}
