import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  static const String _userKey = 'user_profile';

  /// =====================================================
  /// SAVE USER LOCALLY
  /// =====================================================
  static Future<void> saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_userKey, jsonEncode(user.toJson()));
    } catch (e) {
      throw Exception("Failed to save user: $e");
    }
  }

  /// =====================================================
  /// GET USER PROFILE
  /// =====================================================
  static Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final data = prefs.getString(_userKey);

      if (data == null) return null;

      return UserModel.fromJson(jsonDecode(data));
    } catch (e) {
      throw Exception("Failed to fetch user: $e");
    }
  }

  /// =====================================================
  /// UPDATE USER
  /// =====================================================
  static Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  /// =====================================================
  /// GET USER ID
  /// =====================================================
  static Future<String?> getUserId() async {
    final user = await getUser();
    return user?.id;
  }

  /// =====================================================
  /// GET USER ROLE
  /// =====================================================
  static Future<String?> getUserRole() async {
    final user = await getUser();
    return user?.role;
  }

  /// =====================================================
  /// CLEAR USER (LOGOUT)
  /// =====================================================
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
