import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF1E3C72); // Deep premium blue
  static const Color secondaryOrange = Color(0xFFFF5E36); // Warm secondary orange
  static const Color accentGreen = Color(0xFF00B488); // Mint accent green

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0B132B);
  static const Color darkSurface = Color(0xFF1C2541);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF3A506B);

  // General Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, Color(0xFF2A5298)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [secondaryOrange, Color(0xFFFF9F43)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [accentGreen, Color(0xFF2ED573)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Colors.white10,
      Colors.white30,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
