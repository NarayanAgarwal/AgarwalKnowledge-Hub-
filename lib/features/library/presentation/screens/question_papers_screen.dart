import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class QuestionPapersScreen extends StatelessWidget {
  final String userClass;

  const QuestionPapersScreen({super.key, required this.userClass});

  @override
  Widget build(BuildContext context) {
    // Sample archive papers data
    final papers = [
      {'title': 'CBSE Mathematics Board Paper 2024', 'type': 'PYQ (Previous Year Paper)'},
      {'title': 'CBSE Science Model Question Sheet 2025', 'type': 'Model Paper'},
      {'title': 'Grade 5 English Practice Test Paper', 'type': 'Practice Paper'},
      {'title': 'Computer Practical Mock Board Paper', 'type': 'Sample Paper'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Papers Archive'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: papers.length,
        itemBuilder: (context, index) {
          final paper = papers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFEAF5FF),
                child: Icon(Icons.description_outlined, color: AppColors.primaryBlue),
              ),
              title: Text(paper['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(paper['type']!),
              trailing: IconButton(
                icon: const Icon(Icons.download_outlined, color: AppColors.primaryBlue),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading practice exam paper...')));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
