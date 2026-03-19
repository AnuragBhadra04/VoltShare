import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../core/constants/api_endpoints.dart';

class AuthService {
  static final SupabaseClient supabase = Supabase.instance.client;

  // ===============================
  // EMAIL LOGIN
  // ===============================
  static Future<AuthResponse> signInWithEmail(
    String email,
    String password,
  ) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // ===============================
  // GOOGLE LOGIN
  // ===============================
  static Future<void> signInWithGoogle() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://login-callback',
    );
  }

  // ===============================
  // CREATE PROFILE IF NOT EXISTS
  // ===============================
  static Future<void> createUserProfileIfNotExists() async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final existing = await supabase
        .from(ApiEndpoints.users)
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (existing != null) return;

    final data = {
      'id': user.id,
      'name': user.userMetadata?['name'] ?? '',
      'email': user.email,
      'phone': user.phone,
      'photo_url': user.userMetadata?['avatar_url'],
      'role': null,
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      await supabase.from(ApiEndpoints.users).insert(data);
    } catch (e) {
      print("Profile insert error: $e");
    }
  }

  // ===============================
  // GET CURRENT PROFILE
  // ===============================
  static Future<UserModel?> getCurrentUserProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) return null;

    final data = await supabase
        .from(ApiEndpoints.users)
        .select()
        .eq('id', user.id)
        .single();

    return UserModel.fromJson(data);
  }

  // ===============================
  // UPDATE ROLE
  // ===============================
  static Future<void> updateRole(String role) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase
        .from(ApiEndpoints.users)
        .update({'role': role})
        .eq('id', user.id);
  }

  // ===============================
  // LOGOUT
  // ===============================
  static Future<void> logout() async {
    await supabase.auth.signOut();
  }

  // ===============================
  // CURRENT USER
  // ===============================
  static User? get currentUser => supabase.auth.currentUser;

  static String? get currentUserId => supabase.auth.currentUser?.id;
}
