import 'package:flutter/material.dart';

/// The app's palette, matching the proposal wireframes.
class AppColors {
  AppColors._();

  static const background = Color(0xFF16222E);
  static const field = Color(0xFF0F1820);
  static const card = Color(0xFF1C2A38);
  static const text = Color(0xFFF4F2EC);
  static const muted = Color(0xFFB8C2CC);
  static const emptyBar = Color(0xFF2A3A4A);

  static const amber = Color(0xFFE8A33D);
  static const blue = Color(0xFF5B8DEF);
  static const lightBlue = Color(0xFF8FB0F5);

  static const veryWeak = Color(0xFFE0612A);
  static const fair = Color(0xFFB5AE9E);
  static const veryStrong = Color(0xFF3F6FD8);

  /// Colour of the meter bars for a level sent by the engine.
  static Color forLevel(String level) {
    switch (level) {
      case 'VERY_WEAK':
        return veryWeak;
      case 'WEAK':
        return amber;
      case 'FAIR':
        return fair;
      case 'STRONG':
        return blue;
      case 'VERY_STRONG':
        return veryStrong;
      default:
        return muted;
    }
  }

  /// Colour for the level's words, kept readable on the dark background.
  static Color textForLevel(String level) =>
      level == 'STRONG' || level == 'VERY_STRONG' ? lightBlue : forLevel(level);
}
