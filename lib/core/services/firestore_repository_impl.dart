import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../models/attendance.dart';
import '../models/homework.dart';
import '../models/note.dart';
import '../models/notice.dart';
import '../models/quiz.dart';
import '../models/story.dart';
import 'firestore_repository.dart';
import '../constants/app_strings.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  // Local lists to hold mock data when running without active Firebase connection
  final List<UserProfile> _mockUsers = [];
  final List<Attendance> _mockAttendance = [];
  final List<Homework> _mockHomework = [];
  final List<Note> _mockNotes = [];
  final List<Notice> _mockNotices = [];
  final List<Quiz> _mockQuizzes = [];
  final List<Story> _mockStories = [];

  final StreamController<void> _mockUpdateController = StreamController<void>.broadcast();

  bool _useMock = false;

  @override
  bool get isMockEnabled => _useMock;

  void enableMockMode() {
    _useMock = true;
    _seedMockData();
  }

  void _seedMockData() {
    _mockUsers.addAll([
      UserProfile(
        uid: "user_student",
        role: AppStrings.roleStudent,
        name: "Aman Agarwal",
        phone: "+919876543210",
        email: "aman@agarwal.com",
        address: "Mithapur, Patna",
        userClass: "Class 5",
        rollNumber: "12",
        gender: "Male",
        dob: "2015-02-10",
        admissionNumber: "ADM2026512",
        school: "Agarwal Knowledge Hub",
        parentName: "Suresh Agarwal",
        parentMobile: "+919876543220",
        emergencyContact: "+919876543221",
        profilePhotoUrl: "",
        createdDate: DateTime.now(),
        lastLogin: DateTime.now(),
      ),
      UserProfile(
        uid: "user_teacher",
        role: AppStrings.roleTeacher,
        name: "Ms. Anjali Verma",
        phone: "+919876543222",
        email: "anjali@agarwal.com",
        address: "Kankarbagh, Patna",
        userClass: "",
        rollNumber: "",
        gender: "Female",
        dob: "1994-06-25",
        admissionNumber: "TCH202604",
        school: "Agarwal Knowledge Hub",
        parentName: "",
        parentMobile: "",
        emergencyContact: "",
        profilePhotoUrl: "",
        createdDate: DateTime.now(),
        lastLogin: DateTime.now(),
      ),
    ]);

    _mockNotices.addAll([
      Notice(
        id: "notice_1",
        title: "Summer Vacation Announcement",
        content: "Agarwal Knowledge Hub will remain closed from June 1st to June 25th for summer vacations. Online classes for Computer courses will continue as scheduled.",
        type: "Announcement",
        createdDate: DateTime.now().subtract(const Duration(days: 2)),
        sender: "Super Admin",
      ),
      Notice(
        id: "notice_2",
        title: "Mathematics Test Syllabus",
        content: "Syllabus for upcoming Maths test: Fractions, Decimals, and Basic Geometry. Date of test: August 5th.",
        type: "Urgent",
        createdDate: DateTime.now().subtract(const Duration(hours: 4)),
        sender: "Teacher Anjali",
      ),
    ]);

    _mockHomework.addAll([
      Homework(
        id: "hw_1",
        title: "English Grammar Worksheet",
        description: "Complete exercises on Nouns and Pronouns on Page 24 and 25 of your textbook.",
        userClass: "Class 5",
        fileUrl: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
        fileName: "grammar_worksheet.pdf",
        deadline: DateTime.now().add(const Duration(days: 2)),
        teacherId: "user_teacher",
        teacherName: "Anjali Verma",
        createdDate: DateTime.now(),
      ),
      Homework(
        id: "hw_2",
        title: "Computer Practical - Paint",
        description: "Practice drawing geometric shapes in Paint. Bring screenshot output files.",
        userClass: "Computer Practical",
        fileUrl: "",
        fileName: "",
        deadline: DateTime.now().add(const Duration(days: 3)),
        teacherId: "user_teacher",
        teacherName: "Anjali Verma",
        createdDate: DateTime.now(),
      ),
    ]);

    _mockNotes.addAll([
      Note(
        id: "note_1",
        title: "Introduction to Fractions Notes",
        description: "Complete revision PDF for Fractions and Decimals. Recommended for Class 5 CBSE.",
        userClass: "Class 5",
        subject: "Mathematics",
        fileUrl: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
        mediaType: "pdf",
        uploadedBy: "user_teacher",
        uploaderName: "Anjali Verma",
        createdDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Note(
        id: "note_2",
        title: "Computer Basic Hardware Video",
        description: "Explanation of Motherboard, RAM, CPU and Input Devices.",
        userClass: "Computer Theory",
        subject: "Computer Science",
        fileUrl: "https://assets.mixkit.co/videos/preview/mixkit-software-developer-working-on-his-computer-34282-large.mp4",
        mediaType: "video",
        uploadedBy: "user_teacher",
        uploaderName: "Anjali Verma",
        createdDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);

    _mockQuizzes.add(
      Quiz(
        id: "quiz_1",
        title: "General Computer Basics Quiz",
        subject: "Computer Science",
        userClass: "Computer Theory",
        timeLimitMinutes: 10,
        deadline: DateTime.now().add(const Duration(days: 5)),
        teacherId: "user_teacher",
        createdDate: DateTime.now(),
        questions: [
          QuizQuestion(
            questionText: "Which of the following is an input device?",
            options: ["Monitor", "Printer", "Keyboard", "Speaker"],
            correctOptionIndex: 2,
          ),
          QuizQuestion(
            questionText: "What is the brain of the computer system?",
            options: ["RAM", "CPU", "Hard Disk", "Power Supply"],
            correctOptionIndex: 1,
          ),
        ],
      ),
    );

    _mockStories.addAll([
      Story(
        id: "story_1",
        mediaUrl: "https://images.unsplash.com/photo-1546410531-bb4caa6b424d",
        mediaType: "image",
        text: "Interactive Science Lab session today at Agarwal Knowledge Hub! 🧪🎒",
        uploadedBy: "user_teacher",
        uploaderName: "Ms. Anjali Verma",
        durationSeconds: 5,
        createdDate: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ]);

    _mockAttendance.addAll([
      Attendance(
        id: "att_1",
        studentId: "user_student",
        studentName: "Aman Agarwal",
        rollNumber: "12",
        userClass: "Class 5",
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: "Present",
        markedBy: "user_teacher",
      ),
      Attendance(
        id: "att_2",
        studentId: "user_student",
        studentName: "Aman Agarwal",
        rollNumber: "12",
        userClass: "Class 5",
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: "Present",
        markedBy: "user_teacher",
      ),
      Attendance(
        id: "att_3",
        studentId: "user_student",
        studentName: "Aman Agarwal",
        rollNumber: "12",
        userClass: "Class 5",
        date: DateTime.now(),
        status: "Present",
        markedBy: "user_teacher",
      ),
    ]);
  }

  // Users Management Implementation
  @override
  Future<List<UserProfile>> getUsers(String role) async {
    if (_useMock) {
      return _mockUsers.where((u) => u.role == role).toList();
    }
    final snap = await _db
        .collection(AppStrings.colUsers)
        .where('role', isEqualTo: role)
        .get();
    return snap.docs
        .map((doc) => UserProfile.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> createUserProfile(UserProfile profile) async {
    if (_useMock) {
      _mockUsers.removeWhere((u) => u.uid == profile.uid);
      _mockUsers.add(profile);
      return;
    }
    await _db
        .collection(AppStrings.colUsers)
        .doc(profile.uid)
        .set(profile.toFirestore());
  }

  @override
  Future<void> deleteUserProfile(String uid) async {
    if (_useMock) {
      _mockUsers.removeWhere((u) => u.uid == uid);
      return;
    }
    await _db.collection(AppStrings.colUsers).doc(uid).delete();
  }

  // Attendance
  @override
  Stream<List<Attendance>> getStudentAttendance(String studentId) async* {
    if (_useMock) {
      yield _mockAttendance.where((a) => a.studentId == studentId).toList();
      await for (final _ in _mockUpdateController.stream) {
        yield _mockAttendance.where((a) => a.studentId == studentId).toList();
      }
      return;
    }
    yield* _db
        .collection(AppStrings.colAttendance)
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Attendance.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  @override
  Stream<List<Attendance>> getClassAttendance(String userClass, DateTime date) async* {
    if (_useMock) {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));
      yield _mockAttendance.where((a) {
        return a.userClass == userClass && a.date.isAfter(start) && a.date.isBefore(end);
      }).toList();
      await for (final _ in _mockUpdateController.stream) {
        yield _mockAttendance.where((a) {
          return a.userClass == userClass && a.date.isAfter(start) && a.date.isBefore(end);
        }).toList();
      }
      return;
    }
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    yield* _db
        .collection(AppStrings.colAttendance)
        .where('class', isEqualTo: userClass)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Attendance.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<void> markAttendance(Attendance attendance) async {
    if (_useMock) {
      _mockAttendance.add(attendance);
      _mockUpdateController.add(null);
      return;
    }
    await _db.collection(AppStrings.colAttendance).add(attendance.toFirestore());
  }

  // Homework
  @override
  Stream<List<Homework>> getHomeworkList(String userClass) async* {
    if (_useMock) {
      yield _mockHomework.where((hw) => hw.userClass == userClass).toList();
      await for (final _ in _mockUpdateController.stream) {
        yield _mockHomework.where((hw) => hw.userClass == userClass).toList();
      }
      return;
    }
    yield* _db
        .collection(AppStrings.colHomework)
        .where('class', isEqualTo: userClass)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((doc) => Homework.fromFirestore(doc.data(), doc.id))
              .toList();
          list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
          return list;
        });
  }

  @override
  Future<void> uploadHomework(Homework homework) async {
    if (_useMock) {
      _mockHomework.add(homework);
      _mockUpdateController.add(null);
      return;
    }
    await _db.collection(AppStrings.colHomework).add(homework.toFirestore());
  }

  @override
  Future<void> deleteHomework(String homeworkId) async {
    if (_useMock) {
      _mockHomework.removeWhere((hw) => hw.id == homeworkId);
      _mockUpdateController.add(null);
      return;
    }
    await _db.collection(AppStrings.colHomework).doc(homeworkId).delete();
  }

  // Notes/PDFs/Videos
  @override
  Stream<List<Note>> getNotesList(String userClass, String mediaType) async* {
    if (_useMock) {
      yield _mockNotes
          .where((note) => note.userClass == userClass && note.mediaType == mediaType)
          .toList();
      await for (final _ in _mockUpdateController.stream) {
        yield _mockNotes
            .where((note) => note.userClass == userClass && note.mediaType == mediaType)
            .toList();
      }
      return;
    }
    yield* _db
        .collection(AppStrings.colNotes)
        .where('class', isEqualTo: userClass)
        .where('mediaType', isEqualTo: mediaType)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((doc) => Note.fromFirestore(doc.data(), doc.id))
              .toList();
          list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
          return list;
        });
  }

  @override
  Future<void> uploadNote(Note note) async {
    if (_useMock) {
      _mockNotes.add(note);
      _mockUpdateController.add(null);
      return;
    }
    await _db.collection(AppStrings.colNotes).add(note.toFirestore());
  }

  @override
  Future<void> deleteNote(String noteId) async {
    if (_useMock) {
      _mockNotes.removeWhere((n) => n.id == noteId);
      _mockUpdateController.add(null);
      return;
    }
    await _db.collection(AppStrings.colNotes).doc(noteId).delete();
  }

  // Notices
  @override
  Stream<List<Notice>> getNotices() async* {
    if (_useMock) {
      yield _mockNotices;
      await for (final _ in _mockUpdateController.stream) {
        yield _mockNotices;
      }
      return;
    }
    yield* _db
        .collection(AppStrings.colNotifications)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((doc) => Notice.fromFirestore(doc.data(), doc.id))
              .toList();
          list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
          return list;
        });
  }

  @override
  Future<void> publishNotice(Notice notice) async {
    if (_useMock) {
      _mockNotices.add(notice);
      _mockUpdateController.add(null);
      return;
    }
    await _db.collection(AppStrings.colNotifications).add(notice.toFirestore());
  }

  @override
  Future<void> deleteNotice(String noticeId) async {
    if (_useMock) {
      _mockNotices.removeWhere((n) => n.id == noticeId);
      _mockUpdateController.add(null);
      return;
    }
    await _db.collection(AppStrings.colNotifications).doc(noticeId).delete();
  }

  // Quizzes
  @override
  Stream<List<Quiz>> getQuizzes(String userClass) async* {
    if (_useMock) {
      yield _mockQuizzes.where((q) => q.userClass == userClass).toList();
      await for (final _ in _mockUpdateController.stream) {
        yield _mockQuizzes.where((q) => q.userClass == userClass).toList();
      }
      return;
    }
    yield* _db
        .collection(AppStrings.colQuiz)
        .where('class', isEqualTo: userClass)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((doc) => Quiz.fromFirestore(doc.data(), doc.id))
              .toList();
          list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
          return list;
        });
  }

  @override
  Future<void> uploadQuiz(Quiz quiz) async {
    if (_useMock) {
      _mockQuizzes.add(quiz);
      _mockUpdateController.add(null);
      return;
    }
    await _db.collection(AppStrings.colQuiz).add(quiz.toFirestore());
  }

  @override
  Future<void> deleteQuiz(String quizId) async {
    if (_useMock) {
      _mockQuizzes.removeWhere((q) => q.id == quizId);
      _mockUpdateController.add(null);
      return;
    }
    await _db.collection(AppStrings.colQuiz).doc(quizId).delete();
  }

  // Stories
  @override
  Stream<List<Story>> getStories() async* {
    if (_useMock) {
      yield _mockStories;
      await for (final _ in _mockUpdateController.stream) {
        yield _mockStories;
      }
      return;
    }
    yield* _db
        .collection(AppStrings.colStories)
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Story.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<void> publishStory(Story story) async {
    if (_useMock) {
      _mockStories.add(story);
      _mockUpdateController.add(null);
      return;
    }
    await _db.collection(AppStrings.colStories).add(story.toFirestore());
  }

  @override
  Future<void> deleteStory(String storyId) async {
    if (_useMock) {
      _mockStories.removeWhere((s) => s.id == storyId);
      _mockUpdateController.add(null);
      return;
    }
    await _db.collection(AppStrings.colStories).doc(storyId).delete();
  }
}
