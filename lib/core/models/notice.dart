import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  final String id;
  final String title;
  final String content;
  final String type; // 'Urgent', 'General', 'Announcement'
  final DateTime createdDate;
  final String sender;

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.createdDate,
    required this.sender,
  });

  factory Notice.fromFirestore(Map<String, dynamic> data, String id) {
    return Notice(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      type: data['type'] ?? 'General',
      createdDate: (data['createdDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      sender: data['sender'] ?? 'Admin',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'type': type,
      'createdDate': Timestamp.fromDate(createdDate),
      'sender': sender,
    };
  }
}
