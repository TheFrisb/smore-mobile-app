import 'package:flutter/material.dart';

class AppColors {
  // Primary Color
  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFEDF2F7),
      100: Color(0xFFDBE4ED),
      200: Color(0xFFB7C9DB),
      300: Color(0xFF93ADC9),
      400: Color(0xFF6F92B7),
      500: Color(_primaryValue),
      600: Color(0xFF3C5F84),
      700: Color(0xFF2D4763),
      800: Color(0xFF1E2F42),
      900: Color(0xFF0F1721),
    },
  );
  static const int _primaryValue = 0xFF4B76A5;

  // Secondary Color
  static const MaterialColor secondary = MaterialColor(
    _secondaryValue,
    <int, Color>{
      50: Color(0xFFF0F9FF),
      100: Color(0xFFE0F2FE),
      200: Color(0xFFB9E6FE),
      300: Color(0xFF7CD4FD),
      400: Color(0xFF36BFFA),
      500: Color(_secondaryValue),
      600: Color(0xFF0284C7),
      700: Color(0xFF0369A1),
      800: Color(0xFF075985),
      900: Color(0xFF0C4A6E),
    },
  );
  static const int _secondaryValue = 0xFF0BA5EC;

  // Status Colors
  static const MaterialColor success = MaterialColor(
    _successValue,
    <int, Color>{
      50: Color(0xFFECFDF5),
      500: Color(_successValue),
      600: Color(0xFF059669),
    },
  );
  static const int _successValue = 0xFF10B981;

  static const MaterialColor warning = MaterialColor(
    _warningValue,
    <int, Color>{
      50: Color(0xFFFFF7ED),
      500: Color(_warningValue),
      600: Color(0xFFE68200),
    },
  );
  static const int _warningValue = 0xFFFF9100;

  static const MaterialColor info = MaterialColor(
    _infoValue,
    <int, Color>{
      50: Color(0xFFF0F9FF),
      500: Color(_infoValue),
      600: Color(0xFF0091EA),
    },
  );
  static const int _infoValue = 0xFF00B0FF;
}

ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primary.shade800,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondary.shade800,
      error: AppColors.warning.shade600,
      onError: Colors.white,
      surface: AppColors.primary.shade100,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      StatusColors(
        success: AppColors.success,
        warning: AppColors.warning,
        info: AppColors.info,
      ),
    ],
  );
}

class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.success,
    required this.warning,
    required this.info,
  });

  final MaterialColor success;
  final MaterialColor warning;
  final MaterialColor info;

  @override
  ThemeExtension<StatusColors> copyWith() => this;

  @override
  ThemeExtension<StatusColors> lerp(
    ThemeExtension<StatusColors>? other,
    double t,
  ) =>
      this;
}
