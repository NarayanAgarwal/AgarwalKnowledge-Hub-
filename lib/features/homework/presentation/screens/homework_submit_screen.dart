import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/homework.dart';
import '../../../../core/services/progress_provider.dart';
import '../../../../core/widgets/custom_button.dart';

class HomeworkSubmitScreen extends StatefulWidget {
  final Homework homework;

  const HomeworkSubmitScreen({super.key, required this.homework});

  @override
  State<HomeworkSubmitScreen> createState() => _HomeworkSubmitScreenState();
}

class _HomeworkSubmitScreenState extends State<HomeworkSubmitScreen> {
  final _notesController = TextEditingController();
  String _selectedFileName = '';
  bool _isUploading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onPickFile() async {
    setState(() => _isUploading = true);
    // Simulate picking file delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _selectedFileName = 'my_assignment_submission.pdf';
      _isUploading = false;
    });
  }

  void _onSubmit() async {
    if (_selectedFileName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please attach your homework file before submitting.')),
      );
      return;
    }

    setState(() => _isUploading = true);
    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 1.5));

    if (!mounted) return;
    
    // Check if submission is late
    final bool isLate = DateTime.now().isAfter(widget.homework.deadline);
    Provider.of<ProgressProvider>(context, listen: false).submitHomework(
      widget.homework.id,
      isLate: isLate,
    );

    setState(() => _isUploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isLate ? 'Homework submitted LATE successfully!' : 'Homework submitted successfully!'),
        backgroundColor: isLate ? AppColors.error : AppColors.success,
      ),
    );

    Navigator.pop(context); // back to details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Homework'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submitting for: ${widget.homework.title}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            // File Attachment selector card
            InkWell(
              onTap: _onPickFile,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3), style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.primaryBlue.withOpacity(0.02),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.primaryBlue),
                    const SizedBox(height: 12),
                    Text(
                      _selectedFileName.isEmpty ? 'Tap to browse files (PDF or Image)' : _selectedFileName,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                    ),
                    const SizedBox(height: 4),
                    const Text('Max size: 10 MB', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Description / notes
            const Text(
              'Add Student Notes (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Type any comments or notes for your teacher...',
              ),
            ),

            const SizedBox(height: 32),

            CustomButton(
              text: 'Confirm Submission',
              isLoading: _isUploading,
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
