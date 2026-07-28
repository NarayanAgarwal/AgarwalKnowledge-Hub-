import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

abstract class AuthRepository {
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
}
