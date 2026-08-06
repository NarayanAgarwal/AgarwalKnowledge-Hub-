import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/auth_repository.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/constants/app_strings.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepository;
  
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;
  
  // OTP state
  String? _verificationId;
  bool _codeSent = false;
  bool _rememberMe = true;
  bool _isOtpLoginMode = false;
  bool _isEmailOtpMode = false;
  String? _pendingEmail;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get codeSent => _codeSent;
  bool get rememberMe => _rememberMe;
  bool get isOtpLoginMode => _isOtpLoginMode;
  bool get isEmailOtpMode => _isEmailOtpMode;
  String? get pendingEmail => _pendingEmail;
  bool get isMockMode => _authRepository.isMockMode;

  late final Future<void> initializationFuture;

  AuthViewModel(this._authRepository) {
    initializationFuture = _checkSavedSession();
  }

  void toggleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void toggleLoginMode(bool value) {
    _isOtpLoginMode = value;
    _isEmailOtpMode = false;
    _pendingEmail = null;
    _codeSent = false;
    _verificationId = null;
    _errorMessage = null;
    notifyListeners();
  }

  void setEmailOtpMode(bool val) {
    _isEmailOtpMode = val;
    _codeSent = false;
    _verificationId = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> isPhoneRegistered(String phone) async {
    return await _authRepository.isPhoneRegistered(phone);
  }

  Future<bool> registerStudent({
    required String name,
    required String phone,
    required String password,
    required String userClass,
    required String rollNumber,
    required String parentName,
    String email = "",
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final bool alreadyRegistered = await _authRepository.isPhoneRegistered(phone);
      if (alreadyRegistered) {
        throw Exception("Mobile number is already registered.");
      }

      final String uniqueUid = "student_${DateTime.now().millisecondsSinceEpoch}";
      final profile = UserProfile(
        uid: uniqueUid,
        role: AppStrings.roleStudent,
        name: name,
        phone: phone,
        email: email,
        address: "",
        userClass: userClass,
        rollNumber: rollNumber,
        gender: "Male",
        dob: "",
        admissionNumber: "ADM${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
        school: "Agarwal Knowledge Hub",
        parentName: parentName,
        parentMobile: phone,
        emergencyContact: "",
        profilePhotoUrl: "",
        createdDate: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      final registeredProfile = await _authRepository.registerStudent(profile, password);
      if (registeredProfile != null) {
        _userProfile = registeredProfile;
        
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setBool('auto_login', true);
          await prefs.setString('saved_uid', registeredProfile.uid);
        } else {
          await prefs.setBool('auto_login', false);
          await prefs.remove('saved_uid');
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> loginWithPassword(String phone, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _authRepository.loginWithPassword(phone, password);
      if (profile != null) {
        _userProfile = profile;
        
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setBool('auto_login', true);
          await prefs.setString('saved_uid', profile.uid);
        } else {
          await prefs.setBool('auto_login', false);
          await prefs.remove('saved_uid');
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> resetPasswordWithOtp(String phone, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authRepository.updatePassword(phone, newPassword);
      if (success) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception("Failed to update password. Mobile number not found.");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _checkSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Load cached user profile instantly from SharedPreferences to avoid login screen on restart!
    final String? cachedJson = prefs.getString('cached_profile');
    if (cachedJson != null) {
      try {
        _userProfile = UserProfile.fromJson(jsonDecode(cachedJson));
        notifyListeners();
      } catch (e) {
        debugPrint("Error loading cached user profile: $e");
      }
    }

    final bool autoLogin = prefs.getBool('auto_login') ?? false;
    final String? savedUid = prefs.getString('saved_uid');
    
    if (autoLogin && savedUid != null) {
      // 2. Fetch updated profile from Firestore in the background to sync latest details
      try {
        final freshProfile = await _authRepository.getUserProfile(savedUid).timeout(const Duration(seconds: 4));
        if (freshProfile != null) {
          _userProfile = freshProfile;
          await prefs.setString('cached_profile', jsonEncode(freshProfile.toJson()));
          notifyListeners();
        }
      } catch (e) {
        debugPrint("Background session update failed: $e");
        // Keep cached profile if network is down/slow, do NOT reset to null!
      }
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await _authRepository.sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: (verId, resendToken) {
        _verificationId = verId;
        _codeSent = true;
        _isLoading = false;
        notifyListeners();
      },
      onVerificationFailed: (e) {
        _errorMessage = "Firebase Error [${e.code}]: ${e.message ?? 'Verification failed'}";
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> verifyOtp(String smsCode) async {
    if (_verificationId == null) {
      _errorMessage = "Verification ID is missing. Send OTP first.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final UserProfile? profile = await _authRepository.verifyOtp(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      if (profile != null) {
        _userProfile = profile;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_profile', jsonEncode(profile.toJson()));
        if (_rememberMe) {
          await prefs.setBool('auto_login', true);
          await prefs.setString('saved_uid', profile.uid);
        } else {
          await prefs.remove('auto_login');
          await prefs.remove('saved_uid');
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> sendEmailOtp(String email) async {
    _isLoading = true;
    _errorMessage = null;
    _pendingEmail = email;
    notifyListeners();

    await _authRepository.sendEmailOtp(
      email: email,
      onCodeSent: (verId) {
        _verificationId = verId;
        _codeSent = true;
        _isLoading = false;
        notifyListeners();
      },
      onFailed: (error) {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> verifyEmailOtp(String smsCode) async {
    if (_verificationId == null || _pendingEmail == null) {
      _errorMessage = "Verification session expired. Please send code again.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _authRepository.verifyEmailOtp(
        email: _pendingEmail!,
        verificationId: _verificationId!,
        otpCode: smsCode,
      );

      _userProfile = profile;
      _isLoading = false;
      
      if (profile != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_profile', jsonEncode(profile.toJson()));
        if (_rememberMe) {
          await prefs.setBool('auto_login', true);
          await prefs.setString('saved_uid', profile.uid);
        } else {
          await prefs.remove('auto_login');
          await prefs.remove('saved_uid');
        }
      }
      
      notifyListeners();
      return true; // Return true as verification was successful (UI handles if profile is null)
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> completeProfile(UserProfile updatedProfile) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.saveUserProfile(updatedProfile);
      _userProfile = updatedProfile;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_profile', jsonEncode(updatedProfile.toJson()));
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.logout();
      _userProfile = null;
      _codeSent = false;
      _verificationId = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auto_login', false);
      await prefs.remove('saved_uid');
      await prefs.remove('cached_profile');
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
