import 'package:flutter/material.dart';
import '../models/library_folder.dart';
import '../models/media_resource.dart';

class LibraryProvider with ChangeNotifier {
  final List<LibraryFolder> _folders = [];
  final List<MediaResource> _resources = [];

  List<LibraryFolder> get folders => _folders;
  List<MediaResource> get resources => _resources;

  LibraryProvider() {
    _seedMockLibraryData();
  }

  void _seedMockLibraryData() {
    // Seed sample subject folders
    _folders.addAll([
      LibraryFolder(
        id: 'folder_math_1',
        name: 'Math Chapter 1: Fractions',
        colorValue: 0xFF1E3C72, // Deep Blue
        iconCodePoint: 0xe241, // Folder
        userClass: 'Class 5',
        subject: 'Mathematics',
      ),
      LibraryFolder(
        id: 'folder_math_1_sub',
        name: 'Practice worksheets',
        colorValue: 0xFFFF5E36, // Orange
        iconCodePoint: 0xe241,
        parentFolderId: 'folder_math_1',
        userClass: 'Class 5',
        subject: 'Mathematics',
      ),
      LibraryFolder(
        id: 'folder_computer_theory',
        name: 'Computer Theory Videos',
        colorValue: 0xFF00B488, // Green
        iconCodePoint: 0xe241,
        userClass: 'Computer Theory',
        subject: 'Computer Science',
      ),
    ]);

    // Seed mock resources
    _resources.addAll([
      MediaResource(
        id: 'res_fraction_pdf',
        title: 'Equivalent Fractions E-Book',
        description: 'Complete visual textbook chapter covering equivalent fractions rules and figures.',
        fileUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        mediaType: 'pdf',
        sizeInfo: '1.4 MB',
        durationInfo: '',
        folderId: 'folder_math_1',
        userClass: 'Class 5',
        subject: 'Mathematics',
        chapter: 'Chapter 1',
        topic: 'Equivalent Fractions',
        teacherName: 'Anjali Verma',
        createdDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      MediaResource(
        id: 'res_fraction_worksheet',
        title: 'Fractions Grid Sheet',
        description: 'Practice worksheet to match shaded grids with fractions values.',
        fileUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        mediaType: 'sheet',
        sizeInfo: '600 KB',
        durationInfo: '',
        folderId: 'folder_math_1_sub',
        userClass: 'Class 5',
        subject: 'Mathematics',
        chapter: 'Chapter 1',
        topic: 'Fractions Grid',
        teacherName: 'Anjali Verma',
        createdDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      MediaResource(
        id: 'res_hardware_audio',
        title: 'Lesson 1: Motherboard & CPU Audio Lesson',
        description: 'Listen to the audio explanation of CPU sockets, registers, and motherboard buses.',
        fileUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        mediaType: 'audio',
        sizeInfo: '4.2 MB',
        durationInfo: '6:12',
        userClass: 'Computer Theory',
        subject: 'Computer Science',
        chapter: 'Chapter 1',
        topic: 'Motherboards',
        teacherName: 'Anjali Verma',
        createdDate: DateTime.now(),
      ),
      MediaResource(
        id: 'res_computer_exam_paper',
        title: 'Computer Midterm Practice Paper 2025',
        description: 'Mock practice exam papers containing typical objective questions.',
        fileUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        mediaType: 'paper',
        sizeInfo: '1.2 MB',
        durationInfo: '',
        userClass: 'Computer Theory',
        subject: 'Computer Science',
        chapter: 'Practice Exams',
        topic: 'Midterm',
        teacherName: 'Anjali Verma',
        createdDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ]);
  }

  // Get folders in current nesting level
  List<LibraryFolder> getFoldersInParent(String? parentId, String userClass, String subject) {
    return _folders.where((f) {
      return f.parentFolderId == parentId && f.userClass == userClass && f.subject == subject;
    }).toList();
  }

  // Get resources in current folder nesting level
  List<MediaResource> getResourcesInFolder(String? folderId, String userClass, String subject) {
    return _resources.where((r) {
      return r.folderId == folderId && r.userClass == userClass && r.subject == subject;
    }).toList();
  }

  // CRUD Folder management
  void createFolder({
    required String name,
    required int colorValue,
    required int iconCodePoint,
    String? parentFolderId,
    required String userClass,
    required String subject,
  }) {
    final folder = LibraryFolder(
      id: 'folder_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      colorValue: colorValue,
      iconCodePoint: iconCodePoint,
      parentFolderId: parentFolderId,
      userClass: userClass,
      subject: subject,
    );
    _folders.add(folder);
    notifyListeners();
  }

  void renameFolder(String folderId, String newName) {
    final index = _folders.indexWhere((f) => f.id == folderId);
    if (index != -1) {
      _folders[index] = _folders[index].copyWith(name: newName);
      notifyListeners();
    }
  }

  void deleteFolder(String folderId) {
    // Delete folders recursively or change their parent ID
    _folders.removeWhere((f) => f.id == folderId || f.parentFolderId == folderId);
    _resources.removeWhere((r) => r.folderId == folderId);
    notifyListeners();
  }

  // Move files / resources
  void moveResource(String resourceId, String? targetFolderId) {
    final index = _resources.indexWhere((r) => r.id == resourceId);
    if (index != -1) {
      _resources[index] = _resources[index].copyWith(folderId: targetFolderId);
      notifyListeners();
    }
  }
}
