import 'package:flutter/material.dart';
import '../../../../core/services/firestore_repository.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/models/attendance.dart';
import '../../../../core/models/homework.dart';
import '../../../../core/models/note.dart';
import '../../../../core/models/notice.dart';
import '../../../../core/models/quiz.dart';
import '../../../../core/models/story.dart';
import '../../../../core/constants/app_strings.dart';

class WebPanelViewModel with ChangeNotifier {
  final FirestoreRepository _repository;

  // Stats
  int totalStudents = 120;
  int totalTeachers = 15;
  int totalParents = 100;
  int totalClasses = 14;
  int totalNotes = 45;
  int totalPdfs = 50;
  int totalVideos = 22;
  int totalHomeworks = 38;
  int totalQuizzes = 12;
  int totalAttendance = 85;
  int todayActiveUsers = 48;
  double storageUsageGb = 1.45; // out of 5GB free

  // Lists
  List<UserProfile> studentsList = [];
  List<UserProfile> teachersList = [];
  List<Notice> noticesList = [];
  List<Homework> homeworksList = [];
  List<Note> notesList = [];
  List<Quiz> quizzesList = [];
  List<Story> storiesList = [];
  
  // AI Doubt queries list
  List<Map<String, dynamic>> doubtQueries = [
    {
      'id': 'doubt_1',
      'studentName': 'Aman Agarwal',
      'class': 'Class 5',
      'subject': 'Mathematics',
      'question': 'How do we calculate equivalent fractions for 3/4?',
      'replyText': '',
      'status': 'Pending', // 'Pending' | 'Solved' | 'Forwarded'
    },
    {
      'id': 'doubt_2',
      'studentName': 'Rohit Kumar',
      'class': 'Computer Science',
      'subject': 'Computer Theory',
      'question': 'What is the main difference between RAM and ROM?',
      'replyText': 'RAM is volatile memory used for active tasks, whereas ROM is non-volatile used for boot instructions.',
      'status': 'Solved',
    }
  ];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  WebPanelViewModel(this._repository) {
    _loadAllLists();
  }

  Future<void> _loadAllLists() async {
    _isLoading = true;
    notifyListeners();

    try {
      studentsList = await _repository.getUsers(AppStrings.roleStudent);
      teachersList = await _repository.getUsers(AppStrings.roleTeacher);

      _repository.getNotices().listen((data) {
        noticesList = data;
        notifyListeners();
      });

      _repository.getStories().listen((data) {
        storiesList = data;
        notifyListeners();
      });
      
      // Load sample list if database arrays are empty
      if (studentsList.isEmpty) {
        studentsList = [
          UserProfile(
            uid: "std_1",
            role: AppStrings.roleStudent,
            name: "Aman Agarwal",
            phone: "+919876543210",
            email: "aman@gmail.com",
            address: "Patna",
            userClass: "Class 5",
            rollNumber: "12",
            gender: "Male",
            dob: "2015-05-10",
            admissionNumber: "ADM512",
            school: "Agarwal Knowledge Hub",
            parentName: "Suresh Agarwal",
            parentMobile: "+919876543220",
            emergencyContact: "+919876543221",
            profilePhotoUrl: "",
            createdDate: DateTime.now(),
            lastLogin: DateTime.now(),
          ),
          UserProfile(
            uid: "std_2",
            role: AppStrings.roleStudent,
            name: "Divya Kumari",
            phone: "+919876543212",
            email: "divya@gmail.com",
            address: "Patna",
            userClass: "Class 4",
            rollNumber: "08",
            gender: "Female",
            dob: "2016-03-12",
            admissionNumber: "ADM408",
            school: "Agarwal Knowledge Hub",
            parentName: "Suresh Agarwal",
            parentMobile: "+919876543220",
            emergencyContact: "+919876543221",
            profilePhotoUrl: "",
            createdDate: DateTime.now(),
            lastLogin: DateTime.now(),
          )
        ];
      }

      if (teachersList.isEmpty) {
        teachersList = [
          UserProfile(
            uid: "tch_1",
            role: AppStrings.roleTeacher,
            name: "Ms. Anjali Verma",
            phone: "+919876543222",
            email: "anjali@gmail.com",
            address: "Patna",
            userClass: "",
            rollNumber: "",
            gender: "Female",
            dob: "1994-04-12",
            admissionNumber: "TCH04",
            school: "Agarwal Knowledge Hub",
            parentName: "",
            parentMobile: "",
            emergencyContact: "",
            profilePhotoUrl: "",
            createdDate: DateTime.now(),
            lastLogin: DateTime.now(),
          )
        ];
      }
    } catch (e) {
      print("Error loading web panel data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Student CRUD Actions
  Future<void> addStudent(UserProfile student) async {
    await _repository.createUserProfile(student);
    studentsList.add(student);
    notifyListeners();
  }

  Future<void> updateStudent(UserProfile student) async {
    await _repository.createUserProfile(student);
    final idx = studentsList.indexWhere((s) => s.uid == student.uid);
    if (idx != -1) {
      studentsList[idx] = student;
    }
    notifyListeners();
  }

  Future<void> deleteStudent(String uid) async {
    await _repository.deleteUserProfile(uid);
    studentsList.removeWhere((s) => s.uid == uid);
    notifyListeners();
  }

  // Teacher CRUD Actions
  Future<void> addTeacher(UserProfile teacher) async {
    await _repository.createUserProfile(teacher);
    teachersList.add(teacher);
    notifyListeners();
  }

  Future<void> updateTeacher(UserProfile teacher) async {
    await _repository.createUserProfile(teacher);
    final idx = teachersList.indexWhere((t) => t.uid == teacher.uid);
    if (idx != -1) {
      teachersList[idx] = teacher;
    }
    notifyListeners();
  }

  Future<void> deleteTeacher(String uid) async {
    await _repository.deleteUserProfile(uid);
    teachersList.removeWhere((t) => t.uid == uid);
    notifyListeners();
  }

  // Resource Upload Actions
  Future<void> uploadNote(Note note) async {
    await _repository.uploadNote(note);
    notesList.add(note);
    notifyListeners();
  }

  Future<void> deleteNote(String noteId) async {
    await _repository.deleteNote(noteId);
    notesList.removeWhere((n) => n.id == noteId);
    notifyListeners();
  }

  Future<void> uploadHomework(Homework homework) async {
    await _repository.uploadHomework(homework);
    homeworksList.add(homework);
    notifyListeners();
  }

  Future<void> uploadQuiz(Quiz quiz) async {
    await _repository.uploadQuiz(quiz);
    quizzesList.add(quiz);
    notifyListeners();
  }

  Future<void> publishNotice(Notice notice) async {
    await _repository.publishNotice(notice);
    notifyListeners();
  }

  Future<void> uploadStory(Story story) async {
    await _repository.publishStory(story);
    notifyListeners();
  }

  // Doubt Panel Actions
  void replyToDoubt(String id, String reply) {
    final idx = doubtQueries.indexWhere((d) => d['id'] == id);
    if (idx != -1) {
      doubtQueries[idx]['replyText'] = reply;
      doubtQueries[idx]['status'] = 'Solved';
      notifyListeners();
    }
  }

  void forwardDoubt(String id) {
    final idx = doubtQueries.indexWhere((d) => d['id'] == id);
    if (idx != -1) {
      doubtQueries[idx]['status'] = 'Forwarded';
      notifyListeners();
    }
  }

  // Push notifications dispatch simulator
  void sendPushNotification({
    required String title,
    required String body,
    required String targetType, // 'all' | 'class' | 'role'
    String? targetValue,
  }) {
    print("FCM notification dispatched! Target: $targetType ($targetValue), Title: $title");
  }
}
