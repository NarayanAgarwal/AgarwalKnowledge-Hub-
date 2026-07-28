import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import 'custom_button.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.description,
    this.buttonText = 'Dismiss',
  });

  static void show(BuildContext context, {
    required String title,
    required String description,
    String buttonText = 'Dismiss',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        title: title,
        description: description,
        buttonText: buttonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkmark spinning/pulsing animation
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.accentGreen.withOpacity(0.12),
              child: const Icon(Icons.check, color: AppColors.accentGreen, size: 36),
            )
            .animate()
            .scale(duration: 400.ms, curve: Curves.bounceOut)
            .then()
            .shake(duration: 300.ms),
            
            const SizedBox(height: 24),
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
            ),
            
            const SizedBox(height: 32),
            
            CustomButton(
              text: buttonText,
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    )
    .animate()
    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), duration: 250.ms, curve: Curves.easeOutBack);
  }
}
