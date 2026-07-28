import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Standard library catalog dummy values
    final books = [
      {'title': 'Concepts of Physics - Vol 1', 'author': 'H.C. Verma', 'subject': 'Physics'},
      {'title': 'Higher Algebra', 'author': 'Hall & Knight', 'subject': 'Mathematics'},
      {'title': 'Oxford English Grammar', 'author': 'Sidney Greenbaum', 'subject': 'English'},
      {'title': 'Computer Fundamentals', 'author': 'P.K. Sinha', 'subject': 'Computer Science'},
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFEAF5FF),
                child: Icon(Icons.book_outlined, color: AppColors.primaryBlue),
              ),
              title: Text(book['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Author: ${book['author']!} | Subject: ${book['subject']!}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            ),
          );
        },
      ),
    );
  }
}
