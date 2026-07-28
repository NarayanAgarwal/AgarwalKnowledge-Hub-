import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String id;
  final String studentId;
  final String studentName;
  final String rollNumber;
  final String userClass;
  final DateTime date;
  final String status; // 'Present', 'Absent', 'Leave', 'Half Day'
  final String markedBy; // UID of teacher/admin who marked it

  Attendance({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.userClass,
    required this.date,
    required this.status,
    required this.markedBy,
  });

  factory Attendance.fromFirestore(Map<String, dynamic> data, String id) {
    return Attendance(
      id: id,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      rollNumber: data['rollNumber'] ?? '',
      userClass: data['class'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'Present',
      markedBy: data['markedBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'rollNumber': rollNumber,
      'class': userClass,
      'date': Timestamp.fromDate(date),
      'status': status,
      'markedBy': markedBy,
    };
  }
}
