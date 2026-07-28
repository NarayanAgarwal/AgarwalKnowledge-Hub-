import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import 'auth_repository.dart';
import '../constants/app_strings.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Local state for fallback when running without Firebase config
  UserProfile? _mockUser;
  bool _useMock = false;

  void enableMockMode(UserProfile mockUser) {
    _mockUser = mockUser;
    _useMock = true;
  }

  @override
  Stream<User?> get authStateChanges {
    try {
      return _auth.authStateChanges();
    } catch (e) {
      // Return empty stream if Firebase is not initialized
      return Stream.value(null);
    }
  }

  @override
  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException e) onVerificationFailed,
  }) async {
    if (_useMock) {
      // Simulate OTP delay
      await Future.delayed(const Duration(seconds: 1));
      onCodeSent("mock_verification_id", 0);
      return;
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      // Fallback fallback
      onVerificationFailed(
        FirebaseAuthException(
          code: 'firebase_not_initialized',
          message: 'Firebase is not configured yet. Running in mock mode.',
        ),
      );
    }
  }

  @override
  Future<UserProfile?> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    if (_useMock || verificationId == "mock_verification_id") {
      await Future.delayed(const Duration(seconds: 1));
      if (smsCode == "123456" || _mockUser != null) {
        _mockUser = _mockUser ??
            UserProfile(
              uid: "mock_uid_123",
              role: AppStrings.roleStudent,
              name: "Narayan Agarwal",
              phone: "+919876543210",
              email: "narayan@agarwal.com",
              address: "Patna, Bihar",
              userClass: "Class 5",
              rollNumber: "21",
              gender: "Male",
              dob: "2015-05-15",
              admissionNumber: "ADM2026105",
              school: "Agarwal Knowledge Hub",
              parentName: "Sanjay Agarwal",
              parentMobile: "+919876543211",
              emergencyContact: "+919876543212",
              profilePhotoUrl: "",
              createdDate: DateTime.now(),
              lastLogin: DateTime.now(),
            );
        return _mockUser;
      } else {
        throw FirebaseAuthException(code: 'invalid-verification-code', message: 'Incorrect OTP entered.');
      }
    }

    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      UserProfile? profile = await getUserProfile(user.uid);
      if (profile == null) {
        // Create initial skeleton profile for new user
        profile = UserProfile(
          uid: user.uid,
          role: AppStrings.roleStudent,
          name: '',
          phone: user.phoneNumber ?? '',
          email: '',
          address: '',
          userClass: '',
          rollNumber: '',
          gender: '',
          dob: '',
          admissionNumber: '',
          school: 'Agarwal Knowledge Hub',
          parentName: '',
          parentMobile: '',
          emergencyContact: '',
          profilePhotoUrl: '',
          createdDate: DateTime.now(),
          lastLogin: DateTime.now(),
        );
        await saveUserProfile(profile);
      } else {
        // Update last login
        profile = profile.copyWith(lastLogin: DateTime.now());
        await saveUserProfile(profile);
      }
      return profile;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    if (_useMock) {
      _mockUser = null;
      return;
    }
    await _auth.signOut();
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    if (_useMock && _mockUser?.uid == uid) {
      return _mockUser;
    }

    try {
      final DocumentSnapshot doc =
          await _firestore.collection(AppStrings.colUsers).doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      // Fallback logic
    }
    return null;
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    if (_useMock) {
      _mockUser = profile;
      return;
    }
    await _firestore
        .collection(AppStrings.colUsers)
        .doc(profile.uid)
        .set(profile.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<bool> resetPassword(String phoneOrEmail) async {
    // Standard phone auth does not use classic passwords, but we provide email reset flow or dummy verify
    if (_useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    }
    try {
      if (phoneOrEmail.contains('@')) {
        await _auth.sendPasswordResetEmail(email: phoneOrEmail);
        return true;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
