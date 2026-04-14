import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);

  static const Color secondary = Color(0xFFFFB300);
  static const Color secondaryDark = Color(0xFFFF8F00);

  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;
  
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);

  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF1C40F);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  static const Map<int, Color> primarySwatch = {
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: primary,
    600: primaryDark,
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  };
}
