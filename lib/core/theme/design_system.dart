import 'package:flutter/material.dart';

class DesignSystem {
  // Spacing grid tokens
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;

  // Roundness border radius tokens
  static final BorderRadius radius8 = BorderRadius.circular(8.0);
  static final BorderRadius radius12 = BorderRadius.circular(12.0);
  static final BorderRadius radius16 = BorderRadius.circular(16.0);
  static final BorderRadius radius24 = BorderRadius.circular(24.0);
  static final BorderRadius radius32 = BorderRadius.circular(32.0);

  // Premium shadows tokens
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static final List<BoxShadow> activeShadow = [
    BoxShadow(
      color: const Color(0xFF1E3C72).withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
