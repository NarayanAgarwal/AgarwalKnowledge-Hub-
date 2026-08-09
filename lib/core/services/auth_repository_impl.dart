import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
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
  String? _pendingVerifyPhone;
  final Map<String, String> _emailOtpStore = {};

  String _normalizePhone(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    final clean = phone.replaceAll(RegExp(r'\D'), '');
    if (clean.length >= 10) {
      return clean.substring(clean.length - 10);
    }
    return clean;
  }

  @override
  bool get isMockMode => _useMock;

  void enableMockMode([UserProfile? mockUser]) {
    _useMock = true;
    _mockUser = null; // Strictly null on startup until user logs in!
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
    _pendingVerifyPhone = phoneNumber;
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
      if (smsCode != "123456") {
        throw FirebaseAuthException(code: 'invalid-verification-code', message: 'Incorrect OTP entered. (Mock OTP is 123456)');
      }
      
      final phone = _pendingVerifyPhone ?? "";
      final isRegistered = await isPhoneRegistered(phone);
      
      // Load user profile from preferences if exists
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('mock_registered_users');
      if (usersJson != null) {
        final List<dynamic> usersList = jsonDecode(usersJson);
        final match = usersList.firstWhere(
          (u) => _normalizePhone(u['phone']) == _normalizePhone(phone),
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
      
      // Fallback default mock user if it matches default phone
      if (_normalizePhone(phone) == "9876543210") {
        _mockUser = UserProfile(
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
      }

      if (!isRegistered) {
        // Return a skeleton profile for new mock user to trigger registration flow
        final newMockProfile = UserProfile(
          uid: "mock_new_user_${phone.replaceAll('+', '')}",
          role: AppStrings.roleStudent,
          name: "",
          phone: phone,
          email: "",
          address: "",
          userClass: "",
          rollNumber: "",
          gender: "",
          dob: "",
          admissionNumber: "",
          school: "Agarwal Knowledge Hub",
          parentName: "",
          parentMobile: "",
          emergencyContact: "",
          profilePhotoUrl: "",
          createdDate: DateTime.now(),
          lastLogin: DateTime.now(),
        );
        return newMockProfile;
      }
      
      throw FirebaseAuthException(code: 'user-not-found', message: 'No registered user profile found for this mobile number.');
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
  Future<void> sendEmailOtp({
    required String email,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onFailed,
  }) async {
    try {
      final random = Random();
      final otp = (100000 + random.nextInt(900000)).toString();
      final verificationId = "email_ver_${DateTime.now().millisecondsSinceEpoch}";
      
      // Store in memory
      _emailOtpStore[email] = otp;
      _emailOtpStore[verificationId] = email;

      if (_useMock) {
        // Mock email OTP send
        print("Mock Mode Active: Sent Email OTP $otp to $email");
        await Future.delayed(const Duration(seconds: 1));
        onCodeSent(verificationId);
        return;
      }

      // Call Vercel serverless function endpoint
      final origin = Uri.base.origin;
      final url = Uri.parse("$origin/api/send-email");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        onCodeSent(verificationId);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final errorMsg = responseData['error'] ?? "Failed to send email OTP";
        onFailed(errorMsg);
      }
    } catch (e) {
      onFailed("Failed to connect to email service: ${e.toString()}");
    }
  }

  @override
  Future<UserProfile?> verifyEmailOtp({
    required String email,
    required String verificationId,
    required String otpCode,
  }) async {
    final expectedOtp = _emailOtpStore[email];
    if (expectedOtp == null || expectedOtp != otpCode) {
      throw Exception("Incorrect verification code entered.");
    }

    // OTP matches! Clear it from store
    _emailOtpStore.remove(email);
    _emailOtpStore.remove(verificationId);

    // Look up user profile in Firestore
    if (_useMock) {
      // Return default mock student or existing mock profile
      return await getUserProfile("student_user_123");
    }

    // Production mode: Query Firestore users collection by email
    final query = await _firestore
        .collection(AppStrings.colUsers)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      UserProfile profile = UserProfile.fromFirestore(doc.data(), doc.id);
      
      // Update last login
      profile = profile.copyWith(lastLogin: DateTime.now());
      await saveUserProfile(profile);
      return profile;
    }

    // If email is not registered in database, deny access completely!
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
          await _firestore.collection(AppStrings.colUsers).doc(uid).get().timeout(const Duration(seconds: 2));
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
        return usersList.any((u) => _normalizePhone(u['phone']) == _normalizePhone(phone));
      }
      return _normalizePhone(phone) == "9876543210";
    }

    try {
      final normalized = _normalizePhone(phone);
      var query = await _firestore
          .collection(AppStrings.colUsers)
          .where('phone', isEqualTo: normalized)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) return true;

      query = await _firestore
          .collection(AppStrings.colUsers)
          .where('phone', isEqualTo: "+91$normalized")
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
      
      usersList.removeWhere((u) => _normalizePhone(u['phone']) == _normalizePhone(profile.phone));
      
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
      
      if (_normalizePhone(phone) == "9876543210" && password == "123456") {
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
          (u) => _normalizePhone(u['phone']) == _normalizePhone(phone) && u['password'] == password,
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
      final normalized = _normalizePhone(phone);
      var query = await _firestore
          .collection(AppStrings.colUsers)
          .where('phone', isEqualTo: normalized)
          .limit(1)
          .get();
      if (query.docs.isEmpty) {
        query = await _firestore
            .collection(AppStrings.colUsers)
            .where('phone', isEqualTo: "+91$normalized")
            .limit(1)
            .get();
      }
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
          if (_normalizePhone(u['phone']) == _normalizePhone(phone)) {
            u['password'] = newPassword;
            await prefs.setString('mock_registered_users', jsonEncode(usersList));
            return true;
          }
        }
      }
      if (_normalizePhone(phone) == "9876543210") {
        final defaultProfile = await getUserProfile("mock_uid_123");
        if (defaultProfile != null) {
          await registerStudent(defaultProfile, newPassword);
          return true;
        }
      }
      return false;
    }

    try {
      final normalized = _normalizePhone(phone);
      var query = await _firestore
          .collection(AppStrings.colUsers)
          .where('phone', isEqualTo: normalized)
          .limit(1)
          .get();
      if (query.docs.isEmpty) {
        query = await _firestore
            .collection(AppStrings.colUsers)
            .where('phone', isEqualTo: "+91$normalized")
            .limit(1)
            .get();
      }
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
