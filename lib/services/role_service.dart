import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoleService {
  static const String _roleKey = 'user_role';

  static final SupabaseClient _supabase = Supabase.instance.client;

  // =====================================================
  // SAVE ROLE (LOCAL + SUPABASE)
  // =====================================================
  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();

    // Save locally
    await prefs.setString(_roleKey, role);

    // Save in Supabase
    final user = _supabase.auth.currentUser;

    if (user != null) {
      await _supabase.from('users').update({'role': role}).eq('id', user.id);
    }
  }

  // =====================================================
  // GET ROLE (LOCAL FIRST, THEN SUPABASE)
  // =====================================================
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();

    String? role = prefs.getString(_roleKey);

    if (role != null) return role;

    // fallback from Supabase
    final user = _supabase.auth.currentUser;

    if (user == null) return null;

    final data = await _supabase
        .from('users')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    if (data != null && data['role'] != null) {
      await prefs.setString(_roleKey, data['role']);
      return data['role'];
    }

    return null;
  }

  // =====================================================
  // CHECK PROVIDER
  // =====================================================
  static Future<bool> isProvider() async {
    final role = await getRole();

    return role == 'provider';
  }

  // =====================================================
  // CHECK TAKER / CONSUMER
  // =====================================================
  static Future<bool> isConsumer() async {
    final role = await getRole();

    return role == 'consumer';
  }

  // =====================================================
  // CLEAR ROLE
  // =====================================================
  static Future<void> clearRole() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_roleKey);
  }
}
