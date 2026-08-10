import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/system_settings.dart';

class SettingsViewModel with ChangeNotifier {
  SystemSettings _settings = SystemSettings.defaultSettings();
  bool _isLoading = false;
  String? _errorMessage;

  SystemSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get language => _settings.defaultLanguage;
  bool get notificationsEnabled => _settings.pushNotificationsEnabled;

  Future<void> changeLanguage(String newLang) async {
    final updated = _settings.copyWith(defaultLanguage: newLang);
    await updateSettings(updated);
  }

  Future<void> toggleNotifications(bool enabled) async {
    final updated = _settings.copyWith(pushNotificationsEnabled: enabled);
    await updateSettings(updated);
  }

  // Active Sessions
  final List<Map<String, dynamic>> _activeSessions = [
    {
      'id': 'sess_1',
      'device': 'Windows 11 Desktop',
      'browser': 'Google Chrome 127.0',
      'os': 'Windows NT 10.0',
      'lastActive': 'Just now',
      'loginTime': '2026-08-10 10:15 AM',
      'location': 'Patna, Bihar',
      'isCurrent': true,
    },
    {
      'id': 'sess_2',
      'device': 'Samsung Galaxy S24',
      'browser': 'Chrome Mobile',
      'os': 'Android 14',
      'lastActive': '4 hours ago',
      'loginTime': '2026-08-10 06:12 AM',
      'location': 'Patna, Bihar',
      'isCurrent': false,
    },
    {
      'id': 'sess_3',
      'device': 'Apple iPhone 15 Pro',
      'browser': 'Safari Mobile',
      'os': 'iOS 17.5',
      'lastActive': '1 day ago',
      'loginTime': '2026-08-09 09:30 AM',
      'location': 'Muzaffarpur, Bihar',
      'isCurrent': false,
    }
  ];

  // Login History Log
  final List<Map<String, dynamic>> _loginHistory = [
    {
      'timestamp': '2026-08-10 05:30 PM',
      'user': 'abhayff754@gmail.com',
      'role': 'Super Admin',
      'status': 'Success',
      'ip': '157.34.120.45',
      'device': 'Chrome / Windows',
    },
    {
      'timestamp': '2026-08-10 04:12 PM',
      'user': 'abhayff754@gmail.com',
      'role': 'Super Admin',
      'status': 'Failed (Invalid Credentials)',
      'ip': '157.34.120.45',
      'device': 'Chrome / Windows',
    },
    {
      'timestamp': '2026-08-10 09:15 AM',
      'user': 'teacher_anjali@gmail.com',
      'role': 'Teacher',
      'status': 'Success',
      'ip': '157.34.121.12',
      'device': 'Safari / iOS',
    }
  ];

  List<Map<String, dynamic>> get activeSessions => _activeSessions;
  List<Map<String, dynamic>> get loginHistory => _loginHistory;

  SettingsViewModel() {
    loadSettings();
  }

  bool _isFirebaseAvailable() {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> loadSettings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString("system_settings_json");
      if (cachedJson != null) {
        try {
          _settings = SystemSettings.fromMap(jsonDecode(cachedJson));
        } catch (e) {
          print("Error parsing cached settings: $e");
        }
      }

      if (_isFirebaseAvailable()) {
        final doc = await FirebaseFirestore.instance
            .collection('system_settings')
            .doc('global_config')
            .get();

        if (doc.exists && doc.data() != null) {
          _settings = SystemSettings.fromMap(doc.data()!);
          await prefs.setString("system_settings_json", jsonEncode(_settings.toMap()));
        } else {
          _settings = SystemSettings.defaultSettings();
          await FirebaseFirestore.instance
              .collection('system_settings')
              .doc('global_config')
              .set(_settings.toMap());
          await prefs.setString("system_settings_json", jsonEncode(_settings.toMap()));
        }
      } else {
        final lang = prefs.getString("app_language") ?? "English";
        final notify = prefs.getBool("app_notifications_enabled") ?? true;

        _settings = SystemSettings.defaultSettings().copyWith(
          defaultLanguage: lang,
          pushNotificationsEnabled: notify,
        );
      }
    } catch (e) {
      print("System settings load error: $e");
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSettings(SystemSettings newSettings) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _settings = newSettings;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("system_settings_json", jsonEncode(_settings.toMap()));
      await prefs.setString("app_language", _settings.defaultLanguage);
      await prefs.setBool("app_notifications_enabled", _settings.pushNotificationsEnabled);

      if (_isFirebaseAvailable()) {
        await FirebaseFirestore.instance
            .collection('system_settings')
            .doc('global_config')
            .set(_settings.toMap());
      }
    } catch (e) {
      print("System settings update error: $e");
      _errorMessage = e.toString();
      throw Exception("Failed to save settings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Active Sessions Management
  void terminateSession(String sessionId) {
    _activeSessions.removeWhere((s) => s['id'] == sessionId);
    notifyListeners();
  }

  void terminateAllSessions() {
    _activeSessions.removeWhere((s) => s['isCurrent'] != true);
    notifyListeners();
  }

  // Backup Trigger
  Future<void> triggerBackup(String creatorName) async {
    final newBackup = {
      'id': 'bak_${DateTime.now().millisecondsSinceEpoch}',
      'date': DateTime.now().toString().substring(0, 19),
      'size': '${(4.5 + (0.5 * (DateTime.now().second % 5))).toStringAsFixed(1)} MB',
      'status': 'Completed',
      'creator': creatorName,
      'type': 'Manual Cloud Backup',
      'restoreAvailable': true,
    };

    final List<Map<String, dynamic>> updatedHistory = List.from(_settings.backupHistory);
    updatedHistory.insert(0, newBackup);

    final updatedSettings = _settings.copyWith(backupHistory: updatedHistory);
    await updateSettings(updatedSettings);
  }

  // Restore Backup
  Future<void> restoreBackup(String backupId) async {
    // Simulated delay for restore operation
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }
}
