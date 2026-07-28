import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String description;
  final String userClass;
  final String subject;
  final String fileUrl;
  final String mediaType; // 'pdf' | 'video' | 'note'
  final String uploadedBy; // Teacher/Admin UID
  final String uploaderName;
  final DateTime createdDate;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.userClass,
    required this.subject,
    required this.fileUrl,
    required this.mediaType,
    required this.uploadedBy,
    required this.uploaderName,
    required this.createdDate,
  });

  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      userClass: data['class'] ?? '',
      subject: data['subject'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      mediaType: data['mediaType'] ?? 'pdf',
      uploadedBy: data['uploadedBy'] ?? '',
      uploaderName: data['uploaderName'] ?? '',
      createdDate: (data['createdDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'class': userClass,
      'subject': subject,
      'fileUrl': fileUrl,
      'mediaType': mediaType,
      'uploadedBy': uploadedBy,
      'uploaderName': uploaderName,
      'createdDate': Timestamp.fromDate(createdDate),
    };
  }
}
