import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

abstract class AuthRepository {
  bool get isMockMode;
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException e) onVerificationFailed,
  });
  Future<UserProfile?> verifyOtp({
    required String verificationId,
    required String smsCode,
  });
  Future<void> logout();
  Future<UserProfile?> getUserProfile(String uid);
  Future<void> saveUserProfile(UserProfile profile);
  Future<bool> resetPassword(String phoneOrEmail);
  Future<UserProfile?> registerStudent(UserProfile profile, String password);
  Future<UserProfile?> loginWithPassword(String phone, String password);
  Future<bool> updatePassword(String phone, String newPassword);
  Future<bool> isPhoneRegistered(String phone);
}
