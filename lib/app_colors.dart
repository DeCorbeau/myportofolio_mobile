import 'package:flutter/material.dart';

/// Color palette mirrored from the website's static/css/style.css.
class AppColors {
  AppColors._();

  static const Color bgMain = Color(0xFF0C0A14);
  static const Color card = Color(0x08FFFFFF); // rgba(255, 255, 255, 0.03)
  static const Color border = Color(0x14FFFFFF); // rgba(255, 255, 255, 0.08)

  static const Color accentPurple = Color(0xFFA855F7);
  static const Color accentCyan = Color(0xFF22D3EE);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);

  // Darker tones used as button backgrounds so white text stays readable.
  static const Color actionCyan = Color(0xFF0891B2);
  static const Color danger = Color(0xFFDC2626);
}