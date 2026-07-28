import 'package:flutter/material.dart';

class ProgressProvider with ChangeNotifier {
  // Track submission statuses for homework: Map<HomeworkId, String> -> 'Submitted' | 'Late' | 'Pending'
  final Map<String, String> _homeworkSubmissions = {};
  
  // Track quiz results: Map<QuizId, int> -> score
  final Map<String, int> _quizScores = {};

  Map<String, String> get homeworkSubmissions => _homeworkSubmissions;
  Map<String, int> get quizScores => _quizScores;

  String getHomeworkStatus(String homeworkId) {
    return _homeworkSubmissions[homeworkId] ?? 'Pending';
  }

  void submitHomework(String homeworkId, {bool isLate = false}) {
    _homeworkSubmissions[homeworkId] = isLate ? 'Late' : 'Submitted';
    notifyListeners();
  }

  int? getQuizScore(String quizId) {
    return _quizScores[quizId];
  }

  void submitQuizScore(String quizId, int score) {
    _quizScores[quizId] = score;
    notifyListeners();
  }

  // Calculate learning progress based on aggregate numbers
  double calculateLearningProgress(int totalClasses, int totalHomework, int totalQuizzes) {
    if (totalClasses == 0 && totalHomework == 0 && totalQuizzes == 0) return 0.0;
    
    int completedTasks = 0;
    
    // Count homework completions
    completedTasks += _homeworkSubmissions.values.where((v) => v != 'Pending').length;
    
    // Count quiz completions
    completedTasks += _quizScores.length;
    
    int totalTasks = totalHomework + totalQuizzes;
    if (totalTasks == 0) return 0.75; // Default mock progress

    double rate = completedTasks / totalTasks;
    return rate > 1.0 ? 1.0 : rate;
  }
}
