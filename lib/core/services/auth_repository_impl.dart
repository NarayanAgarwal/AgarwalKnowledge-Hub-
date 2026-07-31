import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import 'auth_repository.dart';
import '../constants/app_strings.dart';

class AuthRepositoryImpl implements AuthRepository {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  // Local state for fallback when running without Firebase config
  UserProfile? _mockUser;
  bool _useMock = false;

  @override
  bool get isMockMode => _useMock;

  void enableMockMode(UserProfile mockUser) async {
    _useMock = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMockJson = prefs.getString('mock_user_profile');
      if (savedMockJson != null) {
        final data = jsonDecode(savedMockJson) as Map<String, dynamic>;
        var name = data['name'] ?? mockUser.name;
        if (name == "Aman Agarwal") {
          name = "Narayan Agarwal";
          final updatedData = Map<String, dynamic>.from(data);
          updatedData['name'] = "Narayan Agarwal";
          await prefs.setString('mock_user_profile', jsonEncode(updatedData));
        }
        _mockUser = UserProfile(
          uid: data['uid'] ?? mockUser.uid,
          role: data['role'] ?? mockUser.role,
          name: name,
          phone: data['phone'] ?? mockUser.phone,
          email: data['email'] ?? mockUser.email,
          address: data['address'] ?? mockUser.address,
          userClass: data['class'] ?? mockUser.userClass,
          rollNumber: data['rollNumber'] ?? mockUser.rollNumber,
          gender: data['gender'] ?? mockUser.gender,
          dob: data['dob'] ?? mockUser.dob,
          admissionNumber: data['admissionNumber'] ?? mockUser.admissionNumber,
          school: data['school'] ?? mockUser.school,
          parentName: data['parentName'] ?? mockUser.parentName,
          parentMobile: data['parentMobile'] ?? mockUser.parentMobile,
          emergencyContact: data['emergencyContact'] ?? mockUser.emergencyContact,
          profilePhotoUrl: data['profilePhotoUrl'] ?? mockUser.profilePhotoUrl,
          createdDate: data['createdDate'] != null ? DateTime.parse(data['createdDate']) : mockUser.createdDate,
          lastLogin: data['lastLogin'] != null ? DateTime.parse(data['lastLogin']) : mockUser.lastLogin,
        );
      } else {
        _mockUser = mockUser;
      }
    } catch (_) {
      _mockUser = mockUser;
    }
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
    if (_useMock) {
      if (_mockUser?.uid == uid) {
        return _mockUser;
      }
      try {
        final prefs = await SharedPreferences.getInstance();
        final savedMockJson = prefs.getString('mock_user_profile');
        if (savedMockJson != null) {
          final data = jsonDecode(savedMockJson) as Map<String, dynamic>;
          var name = data['name'] ?? "Narayan Agarwal";
          if (name == "Aman Agarwal") {
            name = "Narayan Agarwal";
          }
          final loadedUser = UserProfile(
            uid: data['uid'] ?? uid,
            role: data['role'] ?? AppStrings.roleStudent,
            name: name,
            phone: data['phone'] ?? "",
            email: data['email'] ?? "",
            address: data['address'] ?? "",
            userClass: data['class'] ?? "",
            rollNumber: data['rollNumber'] ?? "",
            gender: data['gender'] ?? "",
            dob: data['dob'] ?? "",
            admissionNumber: data['admissionNumber'] ?? "",
            school: data['school'] ?? "Agarwal Knowledge Hub",
            parentName: data['parentName'] ?? "",
            parentMobile: data['parentMobile'] ?? "",
            emergencyContact: data['emergencyContact'] ?? "",
            profilePhotoUrl: data['profilePhotoUrl'] ?? "",
            createdDate: data['createdDate'] != null ? DateTime.parse(data['createdDate']) : DateTime.now(),
            lastLogin: data['lastLogin'] != null ? DateTime.parse(data['lastLogin']) : DateTime.now(),
          );
          if (loadedUser.uid == uid) {
            _mockUser = loadedUser;
            return _mockUser;
          }
        }
      } catch (_) {}

      // Fallback default mock user profile
      if (uid == "mock_uid_123" || uid == "student_user_123") {
        _mockUser = _mockUser ?? UserProfile(
          uid: uid,
          role: AppStrings.roleStudent,
          name: "Narayan Agarwal",
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
        );
        return _mockUser;
      }
      return null;
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
      try {
        final prefs = await SharedPreferences.getInstance();
        final mockData = {
          'uid': profile.uid,
          'role': profile.role,
          'name': profile.name,
          'phone': profile.phone,
          'email': profile.email,
          'address': profile.address,
          'class': profile.userClass,
          'rollNumber': profile.rollNumber,
          'gender': profile.gender,
          'dob': profile.dob,
          'admissionNumber': profile.admissionNumber,
          'school': profile.school,
          'parentName': profile.parentName,
          'parentMobile': profile.parentMobile,
          'emergencyContact': profile.emergencyContact,
          'profilePhotoUrl': profile.profilePhotoUrl,
          'createdDate': profile.createdDate.toIso8601String(),
          'lastLogin': profile.lastLogin.toIso8601String(),
        };
        await prefs.setString('mock_user_profile', jsonEncode(mockData));
      } catch (_) {}
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

  @override
  Future<bool> isPhoneRegistered(String phone) async {
    if (_useMock) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('mock_registered_users');
      if (usersJson != null) {
        final List<dynamic> usersList = jsonDecode(usersJson);
        return usersList.any((u) => u['phone'] == phone || u['phone'] == "+91$phone" || phone == "+91${u['phone']}");
      }
      return phone == "+919876543210" || phone == "9876543210";
    }

    try {
      final query = await _firestore
          .collection(AppStrings.colUsers)
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserProfile?> registerStudent(UserProfile profile, String password) async {
    if (_useMock) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('mock_registered_users');
      List<dynamic> usersList = [];
      if (usersJson != null) {
        usersList = jsonDecode(usersJson);
      }
      
      usersList.removeWhere((u) => u['phone'] == profile.phone);
      
      final userData = {
        'uid': profile.uid,
        'role': profile.role,
        'name': profile.name,
        'phone': profile.phone,
        'email': profile.email,
        'address': profile.address,
        'class': profile.userClass,
        'rollNumber': profile.rollNumber,
        'gender': profile.gender,
        'dob': profile.dob,
        'admissionNumber': profile.admissionNumber,
        'school': profile.school,
        'parentName': profile.parentName,
        'parentMobile': profile.parentMobile,
        'emergencyContact': profile.emergencyContact,
        'profilePhotoUrl': profile.profilePhotoUrl,
        'createdDate': profile.createdDate.toIso8601String(),
        'lastLogin': profile.lastLogin.toIso8601String(),
        'password': password,
      };
      
      usersList.add(userData);
      await prefs.setString('mock_registered_users', jsonEncode(usersList));
      
      await saveUserProfile(profile);
      return profile;
    }

    try {
      final profileData = profile.toFirestore();
      profileData['password'] = password;
      
      await _firestore
          .collection(AppStrings.colUsers)
          .doc(profile.uid)
          .set(profileData);
          
      return profile;
    } catch (e) {
      throw Exception("Registration failed: ${e.toString()}");
    }
  }

  @override
  Future<UserProfile?> loginWithPassword(String phone, String password) async {
    if (_useMock) {
      final prefs = await SharedPreferences.getInstance();
      
      if ((phone == "+919876543210" || phone == "9876543210") && password == "123456") {
        final defaultProfile = await getUserProfile("mock_uid_123");
        if (defaultProfile != null) {
          await saveUserProfile(defaultProfile);
          return defaultProfile;
        }
      }
      
      final usersJson = prefs.getString('mock_registered_users');
      if (usersJson != null) {
        final List<dynamic> usersList = jsonDecode(usersJson);
        final match = usersList.firstWhere(
          (u) => (u['phone'] == phone || u['phone'] == "+91$phone" || phone == "+91\${u['phone']}" || "+91$phone" == u['phone'] || phone == u['phone']) && u['password'] == password,
          orElse: () => null,
        );
        if (match != null) {
          final matchedProfile = UserProfile(
            uid: match['uid'],
            role: match['role'] ?? AppStrings.roleStudent,
            name: match['name'],
            phone: match['phone'],
            email: match['email'] ?? "",
            address: match['address'] ?? "",
            userClass: match['class'] ?? "",
            rollNumber: match['rollNumber'] ?? "",
            gender: match['gender'] ?? "",
            dob: match['dob'] ?? "",
            admissionNumber: match['admissionNumber'] ?? "",
            school: match['school'] ?? "Agarwal Knowledge Hub",
            parentName: match['parentName'] ?? "",
            parentMobile: match['parentMobile'] ?? "",
            emergencyContact: match['emergencyContact'] ?? "",
            profilePhotoUrl: match['profilePhotoUrl'] ?? "",
            createdDate: DateTime.parse(match['createdDate']),
            lastLogin: DateTime.now(),
          );
          await saveUserProfile(matchedProfile);
          return matchedProfile;
        }
      }
      throw Exception("Incorrect mobile number or password.");
    }

    try {
      final query = await _firestore
          .collection(AppStrings.colUsers)
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();
          
      if (query.docs.isEmpty) {
        throw Exception("Mobile number is not registered.");
      }
      
      final doc = query.docs.first;
      final data = doc.data();
      if (data['password'] != password) {
        throw Exception("Incorrect password entered.");
      }
      
      final profile = UserProfile.fromFirestore(data, doc.id);
      await _firestore
          .collection(AppStrings.colUsers)
          .doc(profile.uid)
          .update({'lastLogin': Timestamp.fromDate(DateTime.now())});
          
      return profile.copyWith(lastLogin: DateTime.now());
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  @override
  Future<bool> updatePassword(String phone, String newPassword) async {
    if (_useMock) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('mock_registered_users');
      if (usersJson != null) {
        final List<dynamic> usersList = jsonDecode(usersJson);
        for (var u in usersList) {
          if (u['phone'] == phone || u['phone'] == "+91$phone" || phone == "+91\${u['phone']}" || "+91$phone" == u['phone'] || phone == u['phone']) {
            u['password'] = newPassword;
            await prefs.setString('mock_registered_users', jsonEncode(usersList));
            return true;
          }
        }
      }
      if (phone == "+919876543210" || phone == "9876543210") {
        final defaultProfile = await getUserProfile("mock_uid_123");
        if (defaultProfile != null) {
          await registerStudent(defaultProfile, newPassword);
          return true;
        }
      }
      return false;
    }

    try {
      final query = await _firestore
          .collection(AppStrings.colUsers)
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();
          
      if (query.docs.isEmpty) {
        return false;
      }
      
      final docId = query.docs.first.id;
      await _firestore
          .collection(AppStrings.colUsers)
          .doc(docId)
          .update({'password': newPassword});
          
      return true;
    } catch (e) {
      return false;
    }
  }
}
