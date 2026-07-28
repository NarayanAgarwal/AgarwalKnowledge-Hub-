import 'package:cloud_firestore/cloud_firestore.dart';

class Homework {
  final String id;
  final String title;
  final String description;
  final String userClass;
  final String fileUrl;
  final String fileName;
  final DateTime deadline;
  final String teacherId;
  final String teacherName;
  final DateTime createdDate;

  Homework({
    required this.id,
    required this.title,
    required this.description,
    required this.userClass,
    required this.fileUrl,
    required this.fileName,
    required this.deadline,
    required this.teacherId,
    required this.teacherName,
    required this.createdDate,
  });

  factory Homework.fromFirestore(Map<String, dynamic> data, String id) {
    return Homework(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      userClass: data['class'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      fileName: data['fileName'] ?? '',
      deadline: (data['deadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      teacherId: data['teacherId'] ?? '',
      teacherName: data['teacherName'] ?? '',
      createdDate: (data['createdDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'class': userClass,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'deadline': Timestamp.fromDate(deadline),
      'teacherId': teacherId,
      'teacherName': teacherName,
      'createdDate': Timestamp.fromDate(createdDate),
    };
  }
}
