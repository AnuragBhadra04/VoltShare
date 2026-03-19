import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/api_endpoints.dart';

class RoleService {
  static const String _roleKey = 'user_role';

  static final SupabaseClient _supabase = Supabase.instance.client;

  // =====================================================
  // SET ROLE (LOCAL + SUPABASE)
  // =====================================================
  static Future<void> setRole(String role) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      /// SAVE LOCALLY
      await prefs.setString(_roleKey, role);

      /// UPDATE SUPABASE
      final user = _supabase.auth.currentUser;

      if (user != null) {
        await _supabase
            .from(ApiEndpoints.users)
            .update({'role': role})
            .eq('id', user.id);
      }
    } catch (e) {
      throw Exception("Failed to set role: $e");
    }
  }

  // =====================================================
  // GET ROLE (LOCAL FIRST → THEN SUPABASE)
  // =====================================================
  static Future<String?> getRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      /// CHECK LOCAL CACHE
      String? role = prefs.getString(_roleKey);

      if (role != null) {
        return role;
      }

      /// FETCH FROM SUPABASE
      final user = _supabase.auth.currentUser;

      if (user == null) return null;

      final data = await _supabase
          .from(ApiEndpoints.users)
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (data != null && data['role'] != null) {
        /// CACHE LOCALLY
        await prefs.setString(_roleKey, data['role']);

        return data['role'];
      }

      return null;
    } catch (e) {
      throw Exception("Failed to get role: $e");
    }
  }

  // =====================================================
  // SWITCH ROLE
  // =====================================================
  static Future<void> switchRole(String role) async {
    if (role != "consumer" && role != "provider") {
      throw Exception("Invalid role");
    }

    await setRole(role);
  }

  // =====================================================
  // CHECK IF PROVIDER
  // =====================================================
  static Future<bool> isProvider() async {
    final role = await getRole();

    return role == "provider";
  }

  // =====================================================
  // CHECK IF CONSUMER
  // =====================================================
  static Future<bool> isConsumer() async {
    final role = await getRole();

    return role == "consumer";
  }

  // =====================================================
  // CLEAR ROLE (ON LOGOUT)
  // =====================================================
  static Future<void> clearRole() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_roleKey);
  }
}
