import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LeaderboardEntry {
  final int rank;
  final String name;
  final int score;
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    this.isCurrentUser = false,
  });
}

class LeaderboardScreen extends StatelessWidget {
  final String quizId;
  final String quizTitle;

  const LeaderboardScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
  });

  @override
  Widget build(BuildContext context) {
    // Mock rankings for class
    final List<LeaderboardEntry> ranks = [
      LeaderboardEntry(rank: 1, name: "Prerna Agarwal", score: 100),
      LeaderboardEntry(rank: 2, name: "Ravi Shankar Kumar", score: 90),
      LeaderboardEntry(rank: 3, name: "Aman Agarwal", score: 80, isCurrentUser: true),
      LeaderboardEntry(rank: 4, name: "Divya Kumari", score: 75),
      LeaderboardEntry(rank: 5, name: "Saurav Jha", score: 60),
    ];

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Leaderboard'),
      ),
      body: Column(
        children: [
          // Header banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              children: [
                const Icon(Icons.stars, color: AppColors.secondaryOrange, size: 40),
                const SizedBox(height: 8),
                Text(
                  quizTitle,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Classroom Performance Leaderboard',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ranks.length,
              itemBuilder: (context, index) {
                final entry = ranks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: entry.isCurrentUser
                      ? AppColors.primaryBlue.withOpacity(0.12)
                      : (isDark ? AppColors.darkSurface : Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: entry.isCurrentUser ? AppColors.primaryBlue : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: entry.rank == 1
                          ? Colors.yellow[700]
                          : entry.rank == 2
                              ? Colors.grey[400]
                              : entry.rank == 3
                                  ? Colors.brown[300]
                                  : Colors.grey[200],
                      child: Text(
                        '#${entry.rank}',
                        style: TextStyle(
                          color: entry.rank <= 3 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      entry.name,
                      style: TextStyle(
                        fontWeight: entry.isCurrentUser ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: Text(
                      '${entry.score}%',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
