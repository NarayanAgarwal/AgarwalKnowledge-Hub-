import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/homework.dart';
import '../../../../core/services/download_provider.dart';
import '../../../../core/services/progress_provider.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import '../../../dashboard/viewmodels/dashboard_viewmodel.dart';
import 'homework_submit_screen.dart';

class HomeworkDetailScreen extends StatefulWidget {
  final Homework homework;

  const HomeworkDetailScreen({super.key, required this.homework});

  @override
  State<HomeworkDetailScreen> createState() => _HomeworkDetailScreenState();
}

class _HomeworkDetailScreenState extends State<HomeworkDetailScreen> {
  @override
  void initState() {
    super.initState();
    _markAsSeen();
  }

  void _markAsSeen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final authVm = Provider.of<AuthViewModel>(context, listen: false);
        final dashVm = Provider.of<DashboardViewModel>(context, listen: false);
        if (authVm.userProfile != null && authVm.userProfile!.role == 'Student') {
          dashVm.markHomeworkAsSeen(widget.homework.id, authVm.userProfile!.name);
        }
      } catch (e) {
        debugPrint("Error marking homework as seen: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final String status = progressProvider.getHomeworkStatus(widget.homework.id);
    final bool isDownloaded = widget.homework.fileUrl.isEmpty ? false : downloadProvider.isDownloaded(widget.homework.fileUrl);

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
                            widget.homework.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buildStatusBadge(status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Subject: ${widget.homework.subject}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondaryOrange),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Teacher: ${widget.homework.teacherName}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Due Date: ${widget.homework.deadline.day}/${widget.homework.deadline.month}/${widget.homework.deadline.year}',
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
              widget.homework.description,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            
            const SizedBox(height: 24),

            if (widget.homework.fileUrl.isNotEmpty) ...[
              const Text(
                'Homework Attachments & Diagrams',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
              ),
              const SizedBox(height: 12),
              if (widget.homework.fileUrl.startsWith('data:image/') ||
                  widget.homework.fileName.toLowerCase().endsWith('.png') ||
                  widget.homework.fileName.toLowerCase().endsWith('.jpg') ||
                  widget.homework.fileName.toLowerCase().endsWith('.jpeg') ||
                  widget.homework.fileUrl.contains('image'))
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.15)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildAttachmentImage(widget.homework.fileUrl),
                  ),
                )
              else
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                    title: Text(widget.homework.fileName.isNotEmpty ? widget.homework.fileName : 'attachment.pdf'),
                    subtitle: Text(isDownloaded ? 'Downloaded Offline' : 'Size: 1.2 MB'),
                    trailing: isDownloaded
                        ? const Icon(Icons.check_circle, color: AppColors.accentGreen)
                        : IconButton(
                            icon: const Icon(Icons.download, color: AppColors.primaryBlue),
                            onPressed: () {
                              downloadProvider.startDownload(
                                widget.homework.id,
                                widget.homework.fileName.isNotEmpty ? widget.homework.fileName : 'Homework PDF',
                                widget.homework.fileUrl,
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
                      builder: (context) => HomeworkSubmitScreen(homework: widget.homework),
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

  Widget _buildAttachmentImage(String url) {
    if (url.startsWith('data:')) {
      final parts = url.split(';base64,');
      if (parts.length == 2) {
        try {
          return Image.memory(
            base64Decode(parts[1]),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 64),
          );
        } catch (_) {}
      }
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 250,
      placeholder: (context, url) => Container(
        height: 250,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
        errorBuilder: (context, err, st) => const Icon(Icons.broken_image, size: 64),
      ),
    );
  }
}
