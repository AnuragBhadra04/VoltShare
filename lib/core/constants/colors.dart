import 'package:flutter/material.dart';

class AppColors {
  /// Brand Colors
  static const Color primaryPurple = Color(0xFF6C63FF);
  static const Color secondaryGreen = Color(0xFF00C897);

  /// Gradients (used in buttons)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00C897)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Backgrounds
  static const Color background = Color(0xFFF7F8FC);
  static const Color cardBackground = Colors.white;

  /// Text
  static const Color titleText = Color(0xFF1F1F1F);
  static const Color subtitleText = Color(0xFF6B6B6B);

  /// Status Colors
  static const Color success = Color(0xFF00C897);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);

  /// UI Elements
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x14000000);

  /// Map Marker Colors (for charger / EV markers)
  static const Color chargerMarker = Color(0xFF6C63FF);
  static const Color evMarker = Color(0xFF00C897);
}
