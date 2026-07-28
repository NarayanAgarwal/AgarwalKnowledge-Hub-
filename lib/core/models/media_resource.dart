import 'package:cloud_firestore/cloud_firestore.dart';

class MediaResource {
  final String id;
  final String title;
  final String description;
  final String fileUrl;
  final String mediaType; // 'pdf' | 'video' | 'audio' | 'paper' | 'sheet' | 'note'
  final String sizeInfo;
  final String durationInfo; // (for videos and audios)
  final String? folderId; // Link to Folder ID (null if root level in subject)
  final String userClass;
  final String subject;
  final String chapter;
  final String topic;
  final int viewCount;
  final int downloadCount;
  final DateTime createdDate;
  final String teacherName;

  MediaResource({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.mediaType,
    required this.sizeInfo,
    required this.durationInfo,
    this.folderId,
    required this.userClass,
    required this.subject,
    required this.chapter,
    required this.topic,
    this.viewCount = 0,
    this.downloadCount = 0,
    required this.createdDate,
    required this.teacherName,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'mediaType': mediaType,
      'sizeInfo': sizeInfo,
      'durationInfo': durationInfo,
      'folderId': folderId,
      'class': userClass,
      'subject': subject,
      'chapter': chapter,
      'topic': topic,
      'viewCount': viewCount,
      'downloadCount': downloadCount,
      'createdDate': Timestamp.fromDate(createdDate),
      'teacherName': teacherName,
    };
  }

  factory MediaResource.fromFirestore(Map<String, dynamic> data, String id) {
    return MediaResource(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      mediaType: data['mediaType'] ?? 'pdf',
      sizeInfo: data['sizeInfo'] ?? '',
      durationInfo: data['durationInfo'] ?? '',
      folderId: data['folderId'],
      userClass: data['class'] ?? '',
      subject: data['subject'] ?? '',
      chapter: data['chapter'] ?? '',
      topic: data['topic'] ?? '',
      viewCount: data['viewCount'] ?? 0,
      downloadCount: data['downloadCount'] ?? 0,
      createdDate: (data['createdDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      teacherName: data['teacherName'] ?? 'Teacher',
    );
  }

  MediaResource copyWith({
    String? title,
    String? description,
    String? fileUrl,
    String? folderId,
    int? viewCount,
    int? downloadCount,
  }) {
    return MediaResource(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      fileUrl: fileUrl ?? this.fileUrl,
      mediaType: mediaType,
      sizeInfo: sizeInfo,
      durationInfo: durationInfo,
      folderId: folderId ?? this.folderId,
      userClass: userClass,
      subject: subject,
      chapter: chapter,
      topic: topic,
      viewCount: viewCount ?? this.viewCount,
      downloadCount: downloadCount ?? this.downloadCount,
      createdDate: createdDate,
      teacherName: teacherName,
    );
  }
}
