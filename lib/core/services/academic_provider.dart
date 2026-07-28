import 'dart:async';
import 'package:flutter/material.dart';
import '../models/exam.dart';

class AcademicProvider with ChangeNotifier {
  // Attendance states
  String? _activeQrCode;
  int _qrCountdownSeconds = 0;
  Timer? _qrTimer;
  final List<String> _qrMarkedStudentUids = [];

  // GPS parameters (School Geo-coordinates center)
  final double schoolLatitude = 25.5941; 
  final double schoolLongitude = 85.1376; // Patna Coordinates

  // Homework evaluations directory
  final List<Map<String, dynamic>> _submissionsList = [
    {
      'id': 'sub_001',
      'homeworkId': 'hw_1',
      'homeworkTitle': 'Equivalent Fractions sheet',
      'studentName': 'Aman Agarwal',
      'submittedDate': '2026-07-25',
      'fileName': 'aman_fractions.pdf',
      'fileUrl': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      'marks': 0.0,
      'remarks': '',
      'status': 'Submitted', // 'Submitted' | 'Checked' | 'Rejected' | 'Return for Correction'
    },
    {
      'id': 'sub_002',
      'homeworkId': 'hw_2',
      'homeworkTitle': 'Computer Motherboard layout',
      'studentName': 'Aman Agarwal',
      'submittedDate': '2026-07-26',
      'fileName': 'aman_motherboard.png',
      'fileUrl': '',
      'marks': 92.0,
      'remarks': 'Excellent diagram presentation.',
      'status': 'Checked',
    }
  ];

  // Active Exam states
  Exam? _currentExam;
  final Map<String, String> _examDraftAnswers = {};
  bool _isInternetDisconnected = false;
  int _examTimeRemainingSeconds = 0;
  Timer? _examTimer;

  // Certificates list
  final List<Map<String, String>> _certificates = [
    {
      'title': 'Perfect Attendance Award',
      'type': 'Perfect Attendance',
      'date': 'July 2026',
      'description': 'Awarded for maintaining 100% attendance metrics throughout the semester.',
    },
    {
      'title': 'Quiz Master Badge',
      'type': 'Quiz Winner',
      'date': 'July 2026',
      'description': 'Awarded for scoring a perfect 100% in Grade 5 Mathematics fractions quiz.',
    }
  ];

  // Getters
  String? get activeQrCode => _activeQrCode;
  int get qrCountdownSeconds => _qrCountdownSeconds;
  List<Map<String, dynamic>> get submissionsList => _submissionsList;
  Exam? get currentExam => _currentExam;
  Map<String, String> get examDraftAnswers => _examDraftAnswers;
  bool get isInternetDisconnected => _isInternetDisconnected;
  int get examTimeRemainingSeconds => _examTimeRemainingSeconds;
  List<Map<String, String>> get certificates => _certificates;

  // QR CODE Attendance Method
  void generateQrCode() {
    _activeQrCode = 'ATTENDANCE_TOKEN_${DateTime.now().millisecondsSinceEpoch}';
    _qrCountdownSeconds = 60;
    _qrMarkedStudentUids.clear();
    notifyListeners();

    _qrTimer?.cancel();
    _qrTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_qrCountdownSeconds > 0) {
        _qrCountdownSeconds--;
        notifyListeners();
      } else {
        _activeQrCode = null;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  bool markAttendanceViaQr(String scannedToken, String studentUid) {
    if (_activeQrCode == null || scannedToken != _activeQrCode) {
      return false; // QR Code expired or invalid
    }
    if (_qrMarkedStudentUids.contains(studentUid)) {
      return true; // Already marked
    }
    _qrMarkedStudentUids.add(studentUid);
    notifyListeners();
    return true;
  }

  // GPS Location Radius Attendance Method (within 50 meters)
  bool markAttendanceViaGps({
    required double lat,
    required double lon,
    required String studentUid,
  }) {
    // Basic approximate distance calculation in meters
    // 1 deg lat ~ 111,000 meters
    final double latDiff = (lat - schoolLatitude).abs() * 111000;
    final double lonDiff = (lon - schoolLongitude).abs() * 111000;
    final double distanceMeters = latDiff + lonDiff; // Manhattan approximation for speed

    if (distanceMeters <= 80.0) {
      // Inside school boundaries!
      notifyListeners();
      return true;
    }
    return false;
  }

  // Homework Evaluation grading
  void evaluateHomework(String submissionId, double marks, String remarks, String status) {
    final idx = _submissionsList.indexWhere((s) => s['id'] == submissionId);
    if (idx != -1) {
      _submissionsList[idx]['marks'] = marks;
      _submissionsList[idx]['remarks'] = remarks;
      _submissionsList[idx]['status'] = status;
      notifyListeners();
    }
  }

  // Online Exam states
  void startExam(Exam exam) {
    _currentExam = exam;
    _examDraftAnswers.clear();
    _examTimeRemainingSeconds = exam.durationMinutes * 60;
    _isInternetDisconnected = false;
    notifyListeners();

    _examTimer?.cancel();
    _examTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_examTimeRemainingSeconds > 0) {
        _examTimeRemainingSeconds--;
        
        // Simulating random mock internet disconnections to test resume functionality
        if (_examTimeRemainingSeconds % 120 == 0) {
          _isInternetDisconnected = true;
          notifyListeners();
          
          // Reconnect automatically after 6 seconds
          Future.delayed(const Duration(seconds: 6), () {
            _isInternetDisconnected = false;
            notifyListeners();
          });
        }

        notifyListeners();
      } else {
        submitExam();
        timer.cancel();
      }
    });
  }

  void saveAnswerDraft(String questionId, String answer) {
    // Draft answers are saved locally to simulate auto-save
    _examDraftAnswers[questionId] = answer;
    notifyListeners();
  }

  void submitExam() {
    _examTimer?.cancel();
    _currentExam = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _qrTimer?.cancel();
    _examTimer?.cancel();
    super.dispose();
  }
}
