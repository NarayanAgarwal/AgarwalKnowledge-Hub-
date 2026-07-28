import '../models/user_profile.dart';
import '../models/attendance.dart';
import '../models/homework.dart';
import '../models/note.dart';
import '../models/notice.dart';
import '../models/quiz.dart';
import '../models/story.dart';

abstract class FirestoreRepository {
  // User Management
  Future<List<UserProfile>> getUsers(String role);
  Future<void> createUserProfile(UserProfile profile);
  Future<void> deleteUserProfile(String uid);

  // Attendance
  Stream<List<Attendance>> getStudentAttendance(String studentId);
  Stream<List<Attendance>> getClassAttendance(String userClass, DateTime date);
  Future<void> markAttendance(Attendance attendance);

  // Homework
  Stream<List<Homework>> getHomeworkList(String userClass);
  Future<void> uploadHomework(Homework homework);
  Future<void> deleteHomework(String homeworkId);

  // Notes/PDFs/Videos
  Stream<List<Note>> getNotesList(String userClass, String mediaType);
  Future<void> uploadNote(Note note);
  Future<void> deleteNote(String noteId);

  // Notices
  Stream<List<Notice>> getNotices();
  Future<void> publishNotice(Notice notice);
  Future<void> deleteNotice(String noticeId);

  // Quizzes
  Stream<List<Quiz>> getQuizzes(String userClass);
  Future<void> uploadQuiz(Quiz quiz);
  Future<void> deleteQuiz(String quizId);

  // Stories
  Stream<List<Story>> getStories();
  Future<void> publishStory(Story story);
  Future<void> deleteStory(String storyId);
}
