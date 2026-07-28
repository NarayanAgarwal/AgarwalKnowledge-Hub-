import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/download_provider.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Manager'),
      ),
      body: downloadProvider.items.isEmpty
          ? _buildEmptyState(isDark)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: downloadProvider.items.length,
              itemBuilder: (context, index) {
                final item = downloadProvider.items[index];
                final isCompleted = item.status == 'completed';
                final isDownloading = item.status == 'downloading';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isCompleted
                                  ? AppColors.accentGreen.withOpacity(0.1)
                                  : AppColors.primaryBlue.withOpacity(0.1),
                              child: Icon(
                                item.mediaType == 'pdf'
                                    ? Icons.picture_as_pdf
                                    : item.mediaType == 'video'
                                        ? Icons.video_library
                                        : Icons.insert_drive_file,
                                color: isCompleted ? AppColors.accentGreen : AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    item.status.toUpperCase(),
                                    style: TextStyle(
                                      color: isCompleted
                                          ? AppColors.accentGreen
                                          : isDownloading
                                              ? AppColors.primaryBlue
                                              : Colors.grey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isDownloading)
                              IconButton(
                                icon: const Icon(Icons.pause, color: Colors.grey),
                                onPressed: () => downloadProvider.pauseDownload(item.fileUrl),
                              )
                            else if (item.status == 'paused')
                              IconButton(
                                icon: const Icon(Icons.play_arrow, color: AppColors.primaryBlue),
                                onPressed: () => downloadProvider.resumeDownload(item.fileUrl),
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error),
                              onPressed: () => downloadProvider.deleteDownload(item.fileUrl),
                            ),
                          ],
                        ),
                        if (!isCompleted) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: item.progress,
                                  backgroundColor: Colors.grey[300],
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('${(item.progress * 100).toInt()}%', style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.download_for_offline_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No Downloads Found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Lecture materials downloaded will appear offline here.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
