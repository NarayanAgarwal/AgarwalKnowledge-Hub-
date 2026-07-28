class Exam {
  final String id;
  final String title;
  final String subject;
  final int durationMinutes;
  final int totalMarks;
  final int passingMarks;
  final String instructions;
  final DateTime examDate;
  final List<ExamQuestion> questions;

  Exam({
    required this.id,
    required this.title,
    required this.subject,
    required this.durationMinutes,
    required this.totalMarks,
    required this.passingMarks,
    required this.instructions,
    required this.examDate,
    required this.questions,
  });
}

class ExamQuestion {
  final String id;
  final String questionText;
  final String type; // 'mcq' | 'tf' | 'text'
  final List<String>? options;
  final int? correctOptionIndex;

  ExamQuestion({
    required this.id,
    required this.questionText,
    required this.type,
    this.options,
    this.correctOptionIndex,
  });
}
