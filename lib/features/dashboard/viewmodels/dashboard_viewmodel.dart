import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/firestore_repository.dart';
import '../../../core/models/notice.dart';
import '../../../core/models/homework.dart';
import '../../../core/models/note.dart';
import '../../../core/models/quiz.dart';
import '../../../core/models/story.dart';
import '../../../core/models/attendance.dart';

class DashboardViewModel with ChangeNotifier {
  final FirestoreRepository _repository;

  List<Notice> _notices = [];
  List<Homework> _homeworkList = [];
  List<Note> _notes = [];
  List<Note> _videos = [];
  List<Quiz> _quizzes = [];
  List<Story> _stories = [];
  List<Attendance> _attendance = [];
  
  bool _isLoading = false;
  String _searchQuery = "";
  
  // Search results
  List<dynamic> _searchResults = [];

  List<Notice> get notices => _notices;
  List<Homework> get homeworkList => _homeworkList;
  List<Note> get notes => _notes;
  List<Note> get videos => _videos;
  List<Quiz> get quizzes => _quizzes;
  List<Story> get stories => _stories;
  List<Attendance> get attendance => _attendance;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  List<dynamic> get searchResults => _searchResults;

  bool get isMockEnabled => _repository.isMockEnabled;

  DashboardViewModel(this._repository);

  // Load dashboard content based on class
  Future<void> loadDashboardData(String userClass, String studentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Fetch Notices
      _repository.getNotices().listen((data) {
        _notices = data;
        _runSearch(); // Recalculate search if data updates
        notifyListeners();
      });

      // 2. Fetch Homework
      if (userClass.isNotEmpty) {
        _repository.getHomeworkList(userClass).listen((data) {
          _homeworkList = data;
          _runSearch();
          notifyListeners();
        });
      }

      // 3. Fetch Notes & PDFs
      if (userClass.isNotEmpty) {
        _repository.getNotesList(userClass, 'pdf').listen((data) {
          _notes = data;
          _runSearch();
          notifyListeners();
        });
        
        // 4. Fetch Videos
        _repository.getNotesList(userClass, 'video').listen((data) {
          _videos = data;
          _runSearch();
          notifyListeners();
        });

        // 5. Fetch Quizzes
        _repository.getQuizzes(userClass).listen((data) {
          _quizzes = data;
          _runSearch();
          notifyListeners();
        });
      }

      // 6. Fetch Stories
      _repository.getStories().listen((data) {
        _stories = data;
        notifyListeners();
      });

      // 7. Fetch Attendance
      if (studentId.isNotEmpty) {
        _repository.getStudentAttendance(studentId).listen((data) {
          _attendance = data;
          notifyListeners();
        });
      }
    } catch (e) {
      print("Error loading dashboard data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Global Search
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _runSearch();
    notifyListeners();
  }

  void _runSearch() {
    if (_searchQuery.trim().isEmpty) {
      _searchResults = [];
      return;
    }
    
    final query = _searchQuery.toLowerCase();
    final results = [];

    // Search Notes
    for (var n in _notes) {
      if (n.title.toLowerCase().contains(query) || n.subject.toLowerCase().contains(query)) {
        results.add(n);
      }
    }

    // Search Homeworks
    for (var hw in _homeworkList) {
      if (hw.title.toLowerCase().contains(query) || hw.description.toLowerCase().contains(query)) {
        results.add(hw);
      }
    }

    // Search Videos
    for (var v in _videos) {
      if (v.title.toLowerCase().contains(query) || v.subject.toLowerCase().contains(query)) {
        results.add(v);
      }
    }

    // Search Quizzes
    for (var q in _quizzes) {
      if (q.title.toLowerCase().contains(query) || q.subject.toLowerCase().contains(query)) {
        results.add(q);
      }
    }

    // Search Notices
    for (var notice in _notices) {
      if (notice.title.toLowerCase().contains(query) || notice.content.toLowerCase().contains(query)) {
        results.add(notice);
      }
    }

    _searchResults = results;
  }

  Future<void> markHomeworkAsSeen(String homeworkId, String studentName) async {
    await _repository.markHomeworkAsSeen(homeworkId, studentName);
  }
}
