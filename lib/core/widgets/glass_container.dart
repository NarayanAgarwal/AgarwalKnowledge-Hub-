import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final List<Color>? gradientColors;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.blur = 15.0,
    this.padding = const EdgeInsets.all(20),
    this.borderColor,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ??
                  (isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.white.withOpacity(0.4)),
              width: 1.5,
            ),
            gradient: LinearGradient(
              colors: gradientColors ??
                  (isDark
                      ? [
                          Colors.white.withOpacity(0.03),
                          Colors.white.withOpacity(0.08),
                        ]
                      : [
                          Colors.white.withOpacity(0.7),
                          Colors.white.withOpacity(0.3),
                        ]),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
