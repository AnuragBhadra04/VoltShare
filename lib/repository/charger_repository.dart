import '../models/charger_model.dart';
import '../services/api_service.dart';

class ChargerRepository {
  /// Fetch nearby chargers
  static Future<List<ChargerModel>> getNearbyChargers({
    required double latitude,
    required double longitude,
  }) async {
    try {
      return await ApiService.getNearbyChargers(latitude, longitude);
    } catch (e) {
      throw Exception("ChargerRepository getNearbyChargers error: $e");
    }
  }

  /// Add charger
  static Future<void> addCharger(ChargerModel charger) async {
    try {
      await ApiService.addCharger(charger.toJson());
    } catch (e) {
      throw Exception("ChargerRepository addCharger error: $e");
    }
  }

  /// Get all chargers (provider dashboard)
  static Future<List<ChargerModel>> getAllChargers() async {
    try {
      final response = await ApiService.supabase
          .from('chargers')
          .select()
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(
        response,
      );

      return list.map((e) => ChargerModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("ChargerRepository getAllChargers error: $e");
    }
  }

  /// Delete charger
  static Future<void> deleteCharger(String chargerId) async {
    try {
      await ApiService.supabase.from('chargers').delete().eq('id', chargerId);
    } catch (e) {
      throw Exception("ChargerRepository deleteCharger error: $e");
    }
  }
}
