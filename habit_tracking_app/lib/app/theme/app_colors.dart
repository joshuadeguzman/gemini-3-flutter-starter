import 'package:flutter/material.dart';

/// App color palette and ColorScheme generation.
class AppColors {
  /// Primary seed color: a calm purple
  static const Color seedColor = Color(0xFF6C63FF);

  /// Light ColorScheme
  static final ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );

  /// Dark ColorScheme
  static final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );

  /// Predefined habit colors for user selection
  static const List<Color> habitColors = [
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.amberAccent,
    Colors.greenAccent,
    Colors.tealAccent,
    Colors.blueAccent,
    Colors.indigoAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
  ];
}
