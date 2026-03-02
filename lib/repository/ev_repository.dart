import '../models/ev_model.dart';
import '../services/api_service.dart';

class EVRepository {
  /// Fetch nearby EVs
  static Future<List<EVModel>> getNearbyEVs({
    required double latitude,
    required double longitude,
  }) async {
    try {
      return await ApiService.getNearbyEVs(latitude, longitude);
    } catch (e) {
      throw Exception("EVRepository getNearbyEVs error: $e");
    }
  }

  /// Add EV
  static Future<void> addEV(EVModel ev) async {
    try {
      await ApiService.addEV(ev.toJson());
    } catch (e) {
      throw Exception("EVRepository addEV error: $e");
    }
  }

  /// Get all EVs (provider dashboard)
  static Future<List<EVModel>> getAllEVs() async {
    try {
      final response = await ApiService.supabase
          .from('evs')
          .select()
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(
        response,
      );

      return list.map((e) => EVModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("EVRepository getAllEVs error: $e");
    }
  }

  /// Delete EV
  static Future<void> deleteEV(String evId) async {
    try {
      await ApiService.supabase.from('evs').delete().eq('id', evId);
    } catch (e) {
      throw Exception("EVRepository deleteEV error: $e");
    }
  }
}
