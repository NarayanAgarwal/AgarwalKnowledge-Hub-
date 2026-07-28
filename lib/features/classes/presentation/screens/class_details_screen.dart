import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../../../core/models/homework.dart';
import '../../../../core/models/note.dart';
import '../../../../core/models/quiz.dart';
import '../../../homework/presentation/screens/homework_detail_screen.dart';
import '../../../video/presentation/screens/video_player_screen.dart';
import '../../../quiz/presentation/screens/quiz_play_screen.dart';
import '../../../../core/models/exam.dart';
import '../../../quiz/presentation/screens/exam_player_screen.dart';
import '../../../../core/services/download_provider.dart';

class ClassDetailsScreen extends StatelessWidget {
  final String className;
  final String category;

  const ClassDetailsScreen({
    super.key,
    required this.className,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final dashVm = Provider.of<DashboardViewModel>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter local lists for the specific class selected
    final List<Homework> classHw =
        dashVm.homeworkList.where((h) => h.userClass == className).toList();
    final List<Note> classNotes =
        dashVm.notes.where((n) => n.userClass == className).toList();
    final List<Note> classVideos =
        dashVm.videos.where((v) => v.userClass == className).toList();
    final List<Quiz> classQuizzes =
        dashVm.quizzes.where((q) => q.userClass == className).toList();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(className, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          bottom: TabBar(
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.secondaryOrange,
            isScrollable: true,
            tabs: const [
              Tab(icon: Icon(Icons.assignment_outlined), text: 'Homework'),
              Tab(icon: Icon(Icons.picture_as_pdf_outlined), text: 'PDF Notes'),
              Tab(icon: Icon(Icons.video_library_outlined), text: 'Videos'),
              Tab(icon: Icon(Icons.quiz_outlined), text: 'Quizzes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHomeworkTab(context, classHw, isDark),
            _buildPdfNotesTab(context, classNotes, isDark),
            _buildVideosTab(context, classVideos, isDark),
            _buildQuizzesTab(context, classQuizzes, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeworkTab(BuildContext context, List<Homework> homeworks, bool isDark) {
    if (homeworks.isEmpty) return _buildEmptyState(Icons.assignment_turned_in_outlined, 'No Homework Assigned');
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: homeworks.length,
      itemBuilder: (context, index) {
        final hw = homeworks[index];
        final downloadProvider = Provider.of<DownloadProvider>(context, listen: false);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFEFEA),
              child: Icon(Icons.assignment_outlined, color: AppColors.secondaryOrange),
            ),
            title: Text(hw.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hw.description),
                const SizedBox(height: 4),
                Text('Due Date: ${hw.deadline.day}/${hw.deadline.month}/${hw.deadline.year}',
                    style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                downloadProvider.isDownloaded(hw.fileUrl) ? Icons.check_circle : Icons.download_outlined,
                color: downloadProvider.isDownloaded(hw.fileUrl) ? AppColors.accentGreen : AppColors.primaryBlue,
              ),
              onPressed: () {
                if (hw.fileUrl.isNotEmpty) {
                  downloadProvider.startDownload(hw.id, hw.fileName, hw.fileUrl, 'homework');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Starting homework file download...')),
                  );
                }
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeworkDetailScreen(homework: hw),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPdfNotesTab(BuildContext context, List<Note> notes, bool isDark) {
    if (notes.isEmpty) return _buildEmptyState(Icons.description_outlined, 'No PDFs Uploaded Yet');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        final downloadProvider = Provider.of<DownloadProvider>(context, listen: false);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFEAEA),
              child: Icon(Icons.picture_as_pdf_outlined, color: Colors.red),
            ),
            title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(note.description),
            trailing: IconButton(
              icon: Icon(
                downloadProvider.isDownloaded(note.fileUrl) ? Icons.check_circle : Icons.download_outlined,
                color: downloadProvider.isDownloaded(note.fileUrl) ? AppColors.accentGreen : AppColors.primaryBlue,
              ),
              onPressed: () {
                if (note.fileUrl.isNotEmpty) {
                  downloadProvider.startDownload(note.id, note.title, note.fileUrl, 'pdf');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Starting PDF note download...')),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideosTab(BuildContext context, List<Note> videos, bool isDark) {
    if (videos.isEmpty) return _buildEmptyState(Icons.video_library_outlined, 'No Lecture Videos');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(note: video),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    gradient: AppColors.primaryGradient,
                  ),
                  child: const Center(
                    child: Icon(Icons.play_circle_fill_outlined, size: 50, color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text(video.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(video.description),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizzesTab(BuildContext context, List<Quiz> quizzes, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Special Online Exam Card
        Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.secondaryOrange, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFEFEA),
              child: Icon(Icons.assignment_late_outlined, color: AppColors.secondaryOrange),
            ),
            title: const Text('MIDTERM TERM ONLINE EXAMINATION 2026', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Subject: Computer Science | Duration: 45 mins'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryOrange),
              onPressed: () {
                final exam = Exam(
                  id: 'exam_cs_001',
                  title: 'Midterm Computer Science Exam',
                  subject: 'Computer Theory',
                  durationMinutes: 45,
                  totalMarks: 100,
                  passingMarks: 40,
                  instructions: 'Perform all questions. Draft progress is auto-saved.',
                  examDate: DateTime.now(),
                  questions: [
                    ExamQuestion(
                      id: 'eq_1',
                      questionText: 'Which computer hardware component operates as the brain executing programs?',
                      type: 'mcq',
                      options: ['Motherboard', 'CPU', 'Hard Disk Drive', 'Graphics Card'],
                      correctOptionIndex: 1,
                    ),
                    ExamQuestion(
                      id: 'eq_2',
                      questionText: 'Read Only Memory (ROM) is volatile storage memory.',
                      type: 'tf',
                      correctOptionIndex: 1,
                    ),
                  ],
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExamPlayerScreen(exam: exam)),
                );
              },
              child: const Text('Start Exam', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        const Text('Active Classroom Quizzes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        
        if (quizzes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: Text('No other quizzes active')),
          )
        else
          ...quizzes.map((quiz) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEAFFF4),
                    child: Icon(Icons.quiz_outlined, color: AppColors.accentGreen),
                  ),
                  title: Text(quiz.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Questions: ${quiz.questions.length} | Time: ${quiz.timeLimitMinutes} mins'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPlayScreen(quiz: quiz),
                        ),
                      );
                    },
                    child: const Text('Start'),
                  ),
                ),
              )),
      ],
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
