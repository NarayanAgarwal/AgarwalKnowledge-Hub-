import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String id;
  final String mediaUrl;
  final String mediaType; // 'image' | 'video'
  final String text;
  final String uploadedBy; // Teacher/Admin UID
  final String uploaderName;
  final int durationSeconds;
  final DateTime createdDate;

  Story({
    required this.id,
    required this.mediaUrl,
    required this.mediaType,
    required this.text,
    required this.uploadedBy,
    required this.uploaderName,
    required this.durationSeconds,
    required this.createdDate,
  });

  factory Story.fromFirestore(Map<String, dynamic> data, String id) {
    return Story(
      id: id,
      mediaUrl: data['mediaUrl'] ?? '',
      mediaType: data['mediaType'] ?? 'image',
      text: data['text'] ?? '',
      uploadedBy: data['uploadedBy'] ?? '',
      uploaderName: data['uploaderName'] ?? 'Teacher',
      durationSeconds: data['durationSeconds'] ?? 5,
      createdDate: (data['createdDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'text': text,
      'uploadedBy': uploadedBy,
      'uploaderName': uploaderName,
      'durationSeconds': durationSeconds,
      'createdDate': Timestamp.fromDate(createdDate),
    };
  }
}
