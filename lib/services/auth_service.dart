import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  static final SupabaseClient supabase = Supabase.instance.client;

  // =====================================================
  // SEND OTP
  // =====================================================
  static Future<void> sendOTP(String phone) async {
    try {
      await supabase.auth.signInWithOtp(phone: phone);
    } catch (e) {
      throw Exception("Failed to send OTP: $e");
    }
  }

  // =====================================================
  // VERIFY OTP + CREATE USER IF NOT EXISTS
  // =====================================================
  static Future<UserModel?> verifyOTP(String phone, String otp) async {
    try {
      final AuthResponse response = await supabase.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.sms,
      );

      final User? authUser = response.user;

      if (authUser == null) {
        throw Exception("Invalid OTP");
      }

      // ======================================
      // CHECK IF USER EXISTS
      // ======================================
      final existingUser = await supabase
          .from('users')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();

      if (existingUser != null) {
        return UserModel.fromJson(existingUser);
      }

      // ======================================
      // CREATE NEW USER
      // ======================================
      final newUser = {
        'id': authUser.id,
        'name': '',
        'phone': phone,
        'email': authUser.email,
        'photo_url': authUser.userMetadata?['avatar_url'],
        'role': null,
        'created_at': DateTime.now().toIso8601String(),
      };

      await supabase.from('users').insert(newUser);

      return UserModel.fromJson(newUser);
    } catch (e) {
      throw Exception("OTP verification failed: $e");
    }
  }

  // =====================================================
  // GET CURRENT USER PROFILE
  // =====================================================
  static Future<UserModel?> getCurrentUserProfile() async {
    try {
      final User? authUser = supabase.auth.currentUser;

      if (authUser == null) return null;

      final data = await supabase
          .from('users')
          .select()
          .eq('id', authUser.id)
          .single();

      return UserModel.fromJson(data);
    } catch (e) {
      throw Exception("Failed to fetch profile: $e");
    }
  }

  // =====================================================
  // UPDATE USER ROLE (provider / consumer)
  // =====================================================
  static Future<void> updateRole(String role) async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      await supabase.from('users').update({'role': role}).eq('id', user.id);
    } catch (e) {
      throw Exception("Failed to update role: $e");
    }
  }

  // =====================================================
  // GET CURRENT AUTH USER ID
  // =====================================================
  static String? get currentUserId {
    return supabase.auth.currentUser?.id;
  }

  // =====================================================
  // GET CURRENT AUTH USER OBJECT
  // =====================================================
  static User? get currentUser {
    return supabase.auth.currentUser;
  }

  // =====================================================
  // LOGOUT
  // =====================================================
  static Future<void> logout() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }
}
