import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  static const String _userKey = 'user_profile';

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _userKey,
      jsonEncode({
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'photoUrl': user.photoUrl,
      }),
    );
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);

    if (data == null) return null;

    final json = jsonDecode(data);
    return UserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photoUrl'],
    );
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
