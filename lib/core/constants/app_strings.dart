class AppStrings {
  static const String appName = 'Agarwal Knowledge Hub';

  // Role Constants
  static const String roleSuperAdmin = 'Super Admin';
  static const String roleAdmin = 'Admin';
  static const String roleTeacher = 'Teacher';
  static const String roleStudent = 'Student';
  static const String roleParent = 'Parent';

  // Firestore Collection Names
  static const String colUsers = 'users';
  static const String colStudents = 'students';
  static const String colTeachers = 'teachers';
  static const String colParents = 'parents';
  static const String colAdmins = 'admins';
  static const String colClasses = 'classes';
  static const String colSubjects = 'subjects';
  static const String colAttendance = 'attendance';
  static const String colHomework = 'homework';
  static const String colNotes = 'notes';
  static const String colPDF = 'pdf';
  static const String colVideos = 'videos';
  static const String colQuiz = 'quiz';
  static const String colStories = 'stories';
  static const String colNotifications = 'notifications';
  static const String colDownloads = 'downloads';
  static const String colSettings = 'settings';

  // Validation Messages
  static const String valEnterPhone = 'Please enter mobile number';
  static const String valEnterValidPhone = 'Please enter a valid 10-digit number';
  static const String valEnterOtp = 'Please enter OTP';
  static const String valEnterValidOtp = 'OTP must be 6 digits';
  static const String valEnterPassword = 'Please enter password';
  static const String valPasswordShort = 'Password must be at least 6 characters';
  static const String valEnterEmail = 'Please enter email';
  static const String valEnterValidEmail = 'Please enter a valid email';
  static const String valRequiredField = 'This field is required';
}
