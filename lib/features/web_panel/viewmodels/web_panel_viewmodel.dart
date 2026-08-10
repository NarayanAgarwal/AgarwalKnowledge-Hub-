import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/firestore_repository.dart';
import '../../../../core/services/storage_repository.dart';
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
  List<UserProfile> parentsList = [];
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

  final StorageRepository _storageRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isMockEnabled => _repository.isMockEnabled;

  WebPanelViewModel(this._repository, this._storageRepository) {
    _loadAllLists();
    loadTrash();
  }

  Future<String> uploadHomeworkFile(List<int> bytes, String fileName, String mimeType) async {
    return await _storageRepository.uploadFileBytes(
      path: 'homework_attachments',
      bytes: bytes,
      fileName: fileName,
      mimeType: mimeType,
    );
  }

  Future<void> _loadAllLists() async {
    _isLoading = true;
    notifyListeners();

    try {
      _repository.streamUsers(AppStrings.roleStudent).listen((data) {
        studentsList = data;
        // Keep default fallback users if streamed list is empty (mock mode startup)
        if (studentsList.isEmpty) {
          _seedDefaultMockStudents();
        }
        notifyListeners();
      });
      
      _repository.streamUsers(AppStrings.roleTeacher).listen((data) {
        teachersList = data;
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
              isOnline: true,
              lastActive: DateTime.now(),
            )
          ];
        }
        notifyListeners();
      });

      _repository.streamUsers(AppStrings.roleParent).listen((data) {
        parentsList = data;
        if (parentsList.isEmpty) {
          _seedDefaultMockParents();
        }
        notifyListeners();
      });

      _repository.getNotices().listen((data) {
        noticesList = data;
        notifyListeners();
      });

      _repository.getAllHomework().listen((data) {
        homeworksList = data;
        notifyListeners();
      });

      _repository.getStories().listen((data) {
        storiesList = data;
        notifyListeners();
      });
    } catch (e) {
      print("Error loading web panel data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void _seedDefaultMockStudents() {
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
        isOnline: true,
        lastActive: DateTime.now(),
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
        isOnline: false,
        lastActive: DateTime.now().subtract(const Duration(minutes: 45)),
      )
    ];
  }

  // Student CRUD Actions
  Future<void> addStudent(UserProfile student) async {
    await _repository.createUserProfile(student);
    studentsList.add(student);
    notifyListeners();
    await syncParentForStudent(student);
  }

  Future<void> updateStudent(UserProfile student) async {
    await _repository.createUserProfile(student);
    final idx = studentsList.indexWhere((s) => s.uid == student.uid);
    if (idx != -1) {
      studentsList[idx] = student;
    }
    notifyListeners();
    await syncParentForStudent(student);
  }

  Future<void> syncParentForStudent(UserProfile student) async {
    if (student.parentName.trim().isEmpty || student.parentMobile.trim().isEmpty) return;
    
    final parentPhone = student.parentMobile.trim();
    final parentUid = "parent_$parentPhone";
    
    // Create or update parent profile linked to this student
    final parent = UserProfile(
      uid: parentUid,
      role: AppStrings.roleParent,
      name: student.parentName.trim(),
      phone: parentPhone,
      email: "${student.parentName.trim().toLowerCase().replaceAll(' ', '')}@gmail.com", // default format
      address: student.address,
      userClass: student.userClass, // class of the child
      rollNumber: student.rollNumber, // roll number of the child
      gender: "Male",
      dob: "",
      admissionNumber: "PAR-${parentPhone.hashCode.abs().toString().substring(0, 4)}",
      school: student.school,
      parentName: student.name, // Child name
      parentMobile: student.phone, // Child mobile
      emergencyContact: student.phone,
      profilePhotoUrl: "",
      createdDate: DateTime.now(),
      lastLogin: DateTime.now(),
    );
    
    await _repository.createUserProfile(parent);
    
    // Update locally in parentsList
    final idx = parentsList.indexWhere((p) => p.uid == parent.uid);
    if (idx != -1) {
      parentsList[idx] = parent;
    } else {
      parentsList.add(parent);
    }
    notifyListeners();
  }

  void _seedDefaultMockParents() {
    parentsList = [
      UserProfile(
        uid: "parent_9876543211",
        role: AppStrings.roleParent,
        name: "Sanjay Agarwal",
        phone: "+919876543211",
        email: "sanjay@gmail.com",
        address: "Mithapur, Patna",
        userClass: "Class 5",
        rollNumber: "1",
        gender: "Male",
        dob: "",
        admissionNumber: "PAR-1122",
        school: "Agarwal Knowledge Hub",
        parentName: "Narayan Agarwal",
        parentMobile: "+919876543210",
        emergencyContact: "",
        profilePhotoUrl: "",
        createdDate: DateTime.now(),
        lastLogin: DateTime.now(),
        isOnline: true,
        lastActive: DateTime.now(),
      ),
      UserProfile(
        uid: "parent_9876543233",
        role: AppStrings.roleParent,
        name: "Ramesh Kumar",
        phone: "+919876543233",
        email: "ramesh@gmail.com",
        address: "Kankarbagh, Patna",
        userClass: "Class 8",
        rollNumber: "5",
        gender: "Male",
        dob: "",
        admissionNumber: "PAR-3344",
        school: "Agarwal Knowledge Hub",
        parentName: "Amit Kumar",
        parentMobile: "+919876543230",
        emergencyContact: "",
        profilePhotoUrl: "",
        createdDate: DateTime.now(),
        lastLogin: DateTime.now(),
        isOnline: false,
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      UserProfile(
        uid: "parent_9876543255",
        role: AppStrings.roleParent,
        name: "Sunita Devi",
        phone: "+919876543255",
        email: "sunita@gmail.com",
        address: "Patna City, Patna",
        userClass: "Class 3",
        rollNumber: "12",
        gender: "Female",
        dob: "",
        admissionNumber: "PAR-5566",
        school: "Agarwal Knowledge Hub",
        parentName: "Neha Kumari",
        parentMobile: "+919876543250",
        emergencyContact: "",
        profilePhotoUrl: "",
        createdDate: DateTime.now(),
        lastLogin: DateTime.now(),
        isOnline: true,
        lastActive: DateTime.now(),
      ),
    ];
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

  Future<void> deleteNotice(String noticeId) async {
    await _repository.deleteNotice(noticeId);
    noticesList.removeWhere((n) => n.id == noticeId);
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

  // Trash & Delete History Management
  List<UserProfile> trashList = [];

  Future<void> loadTrash() async {
    if (isMockEnabled) return;
    try {
      final snap = await FirebaseFirestore.instance.collection('deleted_users').get();
      trashList = snap.docs.map((doc) => UserProfile.fromFirestore(doc.data(), doc.id)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading trash: $e");
    }
  }

  Future<void> moveToTrash(UserProfile profile) async {
    // 1. Save to trashList locally
    trashList.removeWhere((p) => p.uid == profile.uid);
    trashList.add(profile);
    
    // 2. Remove from active rosters locally
    studentsList.removeWhere((s) => s.uid == profile.uid);
    teachersList.removeWhere((t) => t.uid == profile.uid);
    parentsList.removeWhere((p) => p.uid == profile.uid);
    notifyListeners();

    // 3. Firestore Sync
    if (!isMockEnabled) {
      try {
        final data = profile.toFirestore();
        data['deletedAt'] = Timestamp.now();
        await FirebaseFirestore.instance.collection('deleted_users').doc(profile.uid).set(data);
        await FirebaseFirestore.instance.collection(AppStrings.colUsers).doc(profile.uid).delete();
      } catch (e) {
        debugPrint("Error moving to trash: $e");
      }
    }
  }

  Future<void> restoreFromTrash(UserProfile profile) async {
    // 1. Remove from trashList locally
    trashList.removeWhere((p) => p.uid == profile.uid);
    
    // 2. Put back to active rosters locally
    if (profile.role == AppStrings.roleStudent) {
      studentsList.add(profile);
    } else if (profile.role == AppStrings.roleTeacher) {
      teachersList.add(profile);
    } else if (profile.role == AppStrings.roleParent) {
      parentsList.add(profile);
    }
    notifyListeners();

    // 3. Firestore Sync
    if (!isMockEnabled) {
      try {
        await FirebaseFirestore.instance.collection(AppStrings.colUsers).doc(profile.uid).set(profile.toFirestore());
        await FirebaseFirestore.instance.collection('deleted_users').doc(profile.uid).delete();
      } catch (e) {
        debugPrint("Error restoring from trash: $e");
      }
    }
  }

  Future<void> permanentlyDelete(String uid) async {
    // 1. Remove from trashList locally
    trashList.removeWhere((p) => p.uid == uid);
    notifyListeners();

    // 2. Firestore Sync
    if (!isMockEnabled) {
      try {
        await FirebaseFirestore.instance.collection('deleted_users').doc(uid).delete();
      } catch (e) {
        debugPrint("Error permanently deleting: $e");
      }
    }
  }
}
