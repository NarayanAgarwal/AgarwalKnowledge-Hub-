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
  Future<void> sendEmailOtp({
    required String email,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onFailed,
  });
  Future<UserProfile?> verifyEmailOtp({
    required String email,
    required String verificationId,
    required String otpCode,
  });
  Future<void> logout();
  Future<UserProfile?> getUserProfile(String uid);
  Future<void> saveUserProfile(UserProfile profile);
  Future<bool> resetPassword(String phoneOrEmail);
  Future<UserProfile?> registerStudent(UserProfile profile, String password);
  Future<UserProfile?> loginWithPassword(String phone, String password);
  Future<bool> updatePassword(String phone, String newPassword);
  Future<bool> updatePasswordByEmail(String email, String newPassword);
  Future<bool> isPhoneRegistered(String phone);
  Future<bool> isEmailRegistered(String email);
}
