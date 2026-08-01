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

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get codeSent => _codeSent;
  bool get rememberMe => _rememberMe;
  bool get isOtpLoginMode => _isOtpLoginMode;
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
        email: "",
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
    
    // Require explicit login on first launch (no default true fallback)
    final bool autoLogin = prefs.getBool('auto_login') ?? false;
    final String? savedUid = prefs.getString('saved_uid');
    
    if (autoLogin && savedUid != null) {
      _isLoading = true;
      notifyListeners();
      try {
        _userProfile = await _authRepository.getUserProfile(savedUid).timeout(const Duration(seconds: 2));
      } catch (e) {
        _errorMessage = e.toString();
        _userProfile = null;
      }
      _isLoading = false;
      notifyListeners();
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
        _errorMessage = e.message ?? "Verification failed. Try again.";
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

  Future<void> completeProfile(UserProfile updatedProfile) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.saveUserProfile(updatedProfile);
      _userProfile = updatedProfile;
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
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
