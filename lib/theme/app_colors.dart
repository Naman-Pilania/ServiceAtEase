import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42DB);
  static const Color primarySurface = Color(0xFFEEEDFF);

  // Secondary
  static const Color secondary = Color(0xFFFF6584);
  static const Color secondaryLight = Color(0xFFFF8FA5);
  static const Color secondaryDark = Color(0xFFE04563);

  // Accent / Status
  static const Color success = Color(0xFF00C853);
  static const Color online = Color(0xFF00C853);
  static const Color offline = Color(0xFF9CA3AF);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Backgrounds
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  static const Color cardShadow = Color(0x0A000000);

  // Text
  static const Color textPrimary = Color(0xFF1A1D26);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders / Dividers
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Category Colors
  static const Color categorySalon = Color(0xFFFF6B6B);
  static const Color categoryBeauty = Color(0xFFE091FF);
  static const Color categoryDoctor = Color(0xFF4ECDC4);
  static const Color categoryPlumber = Color(0xFF45B7D1);
  static const Color categoryElectrician = Color(0xFFF7DC6F);
  static const Color categoryCleaning = Color(0xFF82E0AA);
  static const Color categoryPainter = Color(0xFFFF8C42);
  static const Color categoryCarpenter = Color(0xFFA0785A);
  static const Color categoryFitness = Color(0xFFFF6B9D);
  static const Color categoryTutor = Color(0xFF6C63FF);
  static const Color categoryPestControl = Color(0xFF26A69A);
  static const Color categoryAppliance = Color(0xFF5C6BC0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF8B83FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFFFF8FA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient onboardingGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9D97FF), Color(0xFFFF6584)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
