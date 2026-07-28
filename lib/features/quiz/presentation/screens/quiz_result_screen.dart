import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/quiz.dart';
import 'leaderboard_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final Quiz quiz;
  final int scorePercent;
  final int correctAnswers;
  final int totalQuestions;

  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.scorePercent,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPassed = scorePercent >= 60;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Result Status Visual
              CircleAvatar(
                radius: 54,
                backgroundColor: isPassed
                    ? AppColors.accentGreen.withOpacity(0.12)
                    : AppColors.error.withOpacity(0.12),
                child: Icon(
                  isPassed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                  size: 56,
                  color: isPassed ? AppColors.accentGreen : AppColors.error,
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                isPassed ? 'Congratulations!' : 'Keep Practicing!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'You completed the ${quiz.title}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              
              const SizedBox(height: 40),
              
              // Score Container
              Container(
                width: 200,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Text(
                      '$scorePercent%',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const Text(
                      'Your Final Score',
                      style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check, color: AppColors.accentGreen),
                  const SizedBox(width: 8),
                  Text('$correctAnswers Correct'),
                  const SizedBox(width: 24),
                  const Icon(Icons.close, color: AppColors.error),
                  const SizedBox(width: 8),
                  Text('${totalQuestions - correctAnswers} Wrong'),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // Actions
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppColors.primaryBlue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaderboardScreen(quizId: quiz.id, quizTitle: quiz.title),
                    ),
                  );
                },
                child: const Text('View Leaderboard', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close Portal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
