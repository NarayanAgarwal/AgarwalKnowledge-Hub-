import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/exam.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/services/academic_provider.dart';
import 'report_card_screen.dart';

class ExamPlayerScreen extends StatefulWidget {
  final Exam exam;

  const ExamPlayerScreen({super.key, required this.exam});

  @override
  State<ExamPlayerScreen> createState() => _ExamPlayerScreenState();
}

class _ExamPlayerScreenState extends State<ExamPlayerScreen> {
  int _activeQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AcademicProvider>(context, listen: false).startExam(widget.exam);
    });
  }

  String _formatTime(int totalSecs) {
    final int minutes = totalSecs ~/ 60;
    final int seconds = totalSecs % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onSubmit() {
    Provider.of<AcademicProvider>(context, listen: false).submitExam();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ReportCardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final acadProvider = Provider.of<AcademicProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (acadProvider.currentExam == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = widget.exam.questions[_activeQuestionIndex];
    final draftAnswers = acadProvider.examDraftAnswers;

    return WillPopScope(
      onWillPop: () async => false, // Lock back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.exam.title),
          automaticallyImplyLeading: false, // Lock exit
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  'Time Left: ${_formatTime(acadProvider.examTimeRemainingSeconds)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryOrange),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Network Disconnection Buffer Banner
            if (acadProvider.isInternetDisconnected)
              Container(
                color: AppColors.error,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Connection lost. Answers buffered locally. Resuming...',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
              
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question progression
                        Text(
                          'Question ${_activeQuestionIndex + 1} of ${widget.exam.questions.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        
                        GlassContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.questionText,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 24),
                              
                              if (question.type == 'mcq' && question.options != null)
                                ...List.generate(question.options!.length, (index) {
                                  final optionText = question.options![index];
                                  final isSelected = draftAnswers[question.id] == '$index';

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected 
                                            ? AppColors.primaryBlue 
                                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                        width: isSelected ? 2 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      color: isSelected 
                                          ? AppColors.primaryBlue.withOpacity(0.08) 
                                          : Colors.transparent,
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: isSelected ? AppColors.primaryBlue : Colors.grey[300],
                                        child: Text(
                                          String.fromCharCode(65 + index),
                                          style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      title: Text(optionText),
                                      onTap: () {
                                        acadProvider.saveAnswerDraft(question.id, '$index');
                                      },
                                    ),
                                  );
                                }),
                              
                              if (question.type == 'tf')
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTfButton(
                                        'True',
                                        draftAnswers[question.id] == 'true',
                                        () => acadProvider.saveAnswerDraft(question.id, 'true'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildTfButton(
                                        'False',
                                        draftAnswers[question.id] == 'false',
                                        () => acadProvider.saveAnswerDraft(question.id, 'false'),
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_activeQuestionIndex > 0)
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _activeQuestionIndex--;
                                  });
                                },
                                child: const Text('Previous'),
                              )
                            else
                              const SizedBox.shrink(),
                              
                            if (_activeQuestionIndex < widget.exam.questions.length - 1)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _activeQuestionIndex++;
                                  });
                                },
                                child: const Text('Next Question'),
                              )
                            else
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen),
                                onPressed: _onSubmit,
                                child: const Text('Submit Exam'),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTfButton(String label, bool isSelected, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.primaryBlue : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        color: isSelected ? AppColors.primaryBlue.withOpacity(0.08) : Colors.transparent,
      ),
      child: ListTile(
        title: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: onTap,
      ),
    );
  }
}
