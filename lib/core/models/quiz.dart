import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      questionText: map['questionText'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctOptionIndex: map['correctOptionIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }
}

class Quiz {
  final String id;
  final String title;
  final String subject;
  final String userClass;
  final List<QuizQuestion> questions;
  final DateTime deadline;
  final int timeLimitMinutes;
  final String teacherId;
  final DateTime createdDate;

  Quiz({
    required this.id,
    required this.title,
    required this.subject,
    required this.userClass,
    required this.questions,
    required this.deadline,
    required this.timeLimitMinutes,
    required this.teacherId,
    required this.createdDate,
  });

  factory Quiz.fromFirestore(Map<String, dynamic> data, String id) {
    return Quiz(
      id: id,
      title: data['title'] ?? '',
      subject: data['subject'] ?? '',
      userClass: data['class'] ?? '',
      questions: (data['questions'] as List?)
              ?.map((q) => QuizQuestion.fromMap(q as Map<String, dynamic>))
              .toList() ??
          [],
      deadline: (data['deadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      timeLimitMinutes: data['timeLimitMinutes'] ?? 10,
      teacherId: data['teacherId'] ?? '',
      createdDate: (data['createdDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subject': subject,
      'class': userClass,
      'questions': questions.map((q) => q.toMap()).toList(),
      'deadline': Timestamp.fromDate(deadline),
      'timeLimitMinutes': timeLimitMinutes,
      'teacherId': teacherId,
      'createdDate': Timestamp.fromDate(createdDate),
    };
  }
}
