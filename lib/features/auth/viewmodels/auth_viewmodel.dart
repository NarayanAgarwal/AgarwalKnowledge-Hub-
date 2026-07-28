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

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get codeSent => _codeSent;
  bool get rememberMe => _rememberMe;

  AuthViewModel(this._authRepository) {
    _checkSavedSession();
  }

  void toggleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _checkSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final bool autoLogin = prefs.getBool('auto_login') ?? false;
    final String? savedUid = prefs.getString('saved_uid');
    
    if (autoLogin && savedUid != null) {
      _isLoading = true;
      notifyListeners();
      try {
        _userProfile = await _authRepository.getUserProfile(savedUid);
      } catch (e) {
        _errorMessage = e.toString();
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
      await prefs.remove('auto_login');
      await prefs.remove('saved_uid');
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
