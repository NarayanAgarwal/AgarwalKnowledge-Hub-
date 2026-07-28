import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/homework.dart';
import '../../../../core/services/download_provider.dart';
import '../../../../core/services/progress_provider.dart';
import 'homework_submit_screen.dart';

class HomeworkDetailScreen extends StatelessWidget {
  final Homework homework;

  const HomeworkDetailScreen({super.key, required this.homework});

  @override
  Widget build(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final String status = progressProvider.getHomeworkStatus(homework.id);
    final bool isDownloaded = homework.fileUrl.isEmpty ? false : downloadProvider.isDownloaded(homework.fileUrl);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homework Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            homework.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buildStatusBadge(status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Teacher: ${homework.teacherName}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Due Date: ${homework.deadline.day}/${homework.deadline.month}/${homework.deadline.year}',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Instruction Notes',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 8),
            Text(
              homework.description,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            
            const SizedBox(height: 24),

            if (homework.fileUrl.isNotEmpty) ...[
              const Text(
                'Attachments',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(homework.fileName.isNotEmpty ? homework.fileName : 'attachment.pdf'),
                  subtitle: Text(isDownloaded ? 'Downloaded Offline' : 'Size: 1.2 MB'),
                  trailing: isDownloaded
                      ? const Icon(Icons.check_circle, color: AppColors.accentGreen)
                      : IconButton(
                          icon: const Icon(Icons.download, color: AppColors.primaryBlue),
                          onPressed: () {
                            downloadProvider.startDownload(
                              homework.id,
                              homework.fileName.isNotEmpty ? homework.fileName : 'Homework PDF',
                              homework.fileUrl,
                              'pdf',
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Downloading attachment... Check Download Manager')),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 32),
            ],

            if (status == 'Pending')
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppColors.primaryBlue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeworkSubmitScreen(homework: homework),
                    ),
                  );
                },
                child: const Text(
                  'Submit Homework',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
            else if (status == 'Checked')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.assignment_turned_in, color: AppColors.primaryBlue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This homework has been graded by the teacher.\nStatus: Checked | Grade: Excellent (A+)',
                        style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.accentGreen),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This homework has been submitted. Grading is in progress.',
                        style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = Colors.grey[200]!;
    Color text = Colors.grey;
    if (status == 'Submitted') {
      bg = const Color(0xFFEAFFF4);
      text = AppColors.accentGreen;
    } else if (status == 'Checked') {
      bg = const Color(0xFFEAF5FF);
      text = AppColors.primaryBlue;
    } else if (status == 'Late') {
      bg = const Color(0xFFFFEAEA);
      text = AppColors.error;
    } else if (status == 'Pending') {
      bg = const Color(0xFFFFEFEA);
      text = AppColors.secondaryOrange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
