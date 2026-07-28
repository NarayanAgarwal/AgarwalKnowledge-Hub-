import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel with ChangeNotifier {
  static const String _langKey = "app_language";
  static const String _notifyKey = "app_notifications_enabled";

  String _language = "English";
  bool _notificationsEnabled = true;

  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;

  SettingsViewModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString(_langKey) ?? "English";
    _notificationsEnabled = prefs.getBool(_notifyKey) ?? true;
    notifyListeners();
  }

  Future<void> changeLanguage(String newLang) async {
    _language = newLang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, newLang);
  }

  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifyKey, enabled);
  }
}
