import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';

class EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryBlue.withOpacity(0.08),
              child: Icon(icon, color: AppColors.primaryBlue, size: 36),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .slideY(begin: 0.0, end: -0.1, duration: 2.seconds, curve: Curves.easeInOut),
            
            const SizedBox(height: 24),
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    )
    .animate()
    .fade(duration: 400.ms)
    .slideY(begin: 0.1, end: 0.0, duration: 400.ms);
  }
}
