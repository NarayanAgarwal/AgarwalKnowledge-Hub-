import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/services/academic_provider.dart';

class HomeworkEvaluationScreen extends StatefulWidget {
  const HomeworkEvaluationScreen({super.key});

  @override
  State<HomeworkEvaluationScreen> createState() => _HomeworkEvaluationScreenState();
}

class _HomeworkEvaluationScreenState extends State<HomeworkEvaluationScreen> {
  final _remarksController = TextEditingController();
  final _marksController = TextEditingController();
  
  Map<String, dynamic>? _selectedSubmission;

  @override
  void dispose() {
    _remarksController.dispose();
    _marksController.dispose();
    super.dispose();
  }

  void _onEvaluate(AcademicProvider provider, String status) {
    if (_selectedSubmission == null) return;
    
    final double marks = double.tryParse(_marksController.text.trim()) ?? 0.0;
    final String remarks = _remarksController.text.trim();

    provider.evaluateHomework(_selectedSubmission!['id'], marks, remarks, status);

    _remarksController.clear();
    _marksController.clear();
    
    setState(() {
      _selectedSubmission = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Homework status updated to: $status')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final acadProvider = Provider.of<AcademicProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homework Evaluation Console'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Submissions list
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: acadProvider.submissionsList.length,
              itemBuilder: (context, index) {
                final sub = acadProvider.submissionsList[index];
                final isPending = sub['status'] == 'Submitted';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.assignment)),
                    title: Text(sub['homeworkTitle']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Student: ${sub['studentName']} | Date: ${sub['submittedDate']}'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPending ? AppColors.secondaryOrange.withOpacity(0.12) : AppColors.accentGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        sub['status'],
                        style: TextStyle(
                          color: isPending ? AppColors.secondaryOrange : AppColors.accentGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedSubmission = sub;
                        _remarksController.text = sub['remarks'] ?? '';
                        _marksController.text = sub['marks'] > 0 ? '${sub['marks']}' : '';
                      });
                    },
                  ),
                );
              },
            ),
          ),
          
          // Right: Grading details form
          if (_selectedSubmission != null)
            Container(
              width: 380,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                border: Border(
                  left: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grading: ${_selectedSubmission!['studentName']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedSubmission!['homeworkTitle'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Divider(height: 32),
                    
                    CustomTextField(
                      controller: _marksController,
                      labelText: 'Award Score (out of 100)',
                      hintText: 'e.g. 95',
                      prefixIcon: Icons.score,
                      keyboardType: TextInputType.number,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    CustomTextField(
                      controller: _remarksController,
                      labelText: 'Teacher Remarks / Feedback',
                      hintText: 'Good effort, correct formatting...',
                      prefixIcon: Icons.comment,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGreen,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _onEvaluate(acadProvider, 'Checked'),
                            child: const Text('Approve'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _onEvaluate(acadProvider, 'Return for Correction'),
                            child: const Text('Return'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomButton(
                      text: 'Reject Submission',
                      color: AppColors.error,
                      onPressed: () => _onEvaluate(acadProvider, 'Rejected'),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
