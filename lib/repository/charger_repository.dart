import '../models/charger_model.dart';
import '../services/api_service.dart';

class ChargerRepository {
  /// ===============================
  /// GET NEARBY CHARGERS
  /// ===============================
  Future<List<ChargerModel>> getNearbyChargers({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    try {
      final chargers = await ApiService.getNearbyChargers(
        latitude,
        longitude,
        radiusKm: radiusKm,
      );

      return chargers;
    } catch (e) {
      throw Exception("Failed to fetch chargers: $e");
    }
  }

  /// ===============================
  /// ADD CHARGER
  /// ===============================
  Future<void> addCharger(ChargerModel charger) async {
    try {
      await ApiService.addCharger(charger.toJson());
    } catch (e) {
      throw Exception("Failed to add charger: $e");
    }
  }

  /// ===============================
  /// GET PROVIDER CHARGERS
  /// ===============================
  Future<List<ChargerModel>> getProviderChargers(String providerId) async {
    try {
      final response = await ApiService.supabase
          .from('chargers')
          .select()
          .eq('provider_id', providerId)
          .order('created_at', ascending: false);

      final list = List<Map<String, dynamic>>.from(response);

      return list.map((e) => ChargerModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to fetch provider chargers: $e");
    }
  }

  /// ===============================
  /// DELETE CHARGER
  /// ===============================
  Future<void> deleteCharger(String id) async {
    try {
      await ApiService.supabase.from('chargers').delete().eq('id', id);
    } catch (e) {
      throw Exception("Failed to delete charger: $e");
    }
  }
}
