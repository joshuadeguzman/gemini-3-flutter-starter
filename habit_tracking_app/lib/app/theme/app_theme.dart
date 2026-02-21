import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App theme configuration using Material 3.
class AppTheme {
  /// Light theme data
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColors.lightScheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
    );
  }

  /// Dark theme data
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColors.darkScheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
