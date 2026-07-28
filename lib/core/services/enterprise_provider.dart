import 'package:flutter/material.dart';
import '../models/institute.dart';
import '../models/audit_log.dart';

class EnterpriseProvider with ChangeNotifier {
  // Multi-Institute rosters
  final List<Institute> _institutes = [];
  
  // Audit Logs database
  final List<AuditLog> _auditLogs = [];

  // Backup logs
  final List<Map<String, String>> _backupHistory = [
    {
      'id': 'bak_001',
      'date': '2026-07-25 04:00 AM',
      'type': 'Automatic Daily',
      'size': '4.2 MB',
      'status': 'Completed',
    },
    {
      'id': 'bak_002',
      'date': '2026-07-26 12:15 PM',
      'type': 'Manual Cloud Backup',
      'size': '4.5 MB',
      'status': 'Completed',
    }
  ];

  // Active settings configuration
  String _currentLanguage = 'en'; // 'en' | 'hi'
  String _activeInstituteId = 'inst_akh';
  
  // Custom branches roster
  final List<Map<String, dynamic>> _branchesList = [
    {
      'id': 'branch_patna',
      'name': 'Patna Main Branch',
      'address': 'Mithapur, Patna',
      'studentCount': 120,
      'teacherCount': 15,
    },
    {
      'id': 'branch_muzaffarpur',
      'name': 'Muzaffarpur Branch',
      'address': 'Kalyani, Muzaffarpur',
      'studentCount': 45,
      'teacherCount': 6,
    }
  ];

  // Getters
  List<Institute> get institutes => _institutes;
  List<AuditLog> get auditLogs => _auditLogs;
  List<Map<String, String>> get backupHistory => _backupHistory;
  String get currentLanguage => _currentLanguage;
  String get activeInstituteId => _activeInstituteId;
  List<Map<String, dynamic>> get branchesList => _branchesList;

  EnterpriseProvider() {
    _seedMockEnterpriseData();
  }

  void _seedMockEnterpriseData() {
    // Seed core default institute
    _institutes.add(
      Institute(
        id: 'inst_akh',
        name: 'Agarwal Knowledge Hub',
        logoUrl: '',
        primaryColorHex: '1E3C72', // Deep Blue
        secondaryColorHex: 'FF5E36', // Orange
        contactEmail: 'info@agarwalknowledgehub.com',
        contactPhone: '+919876543210',
        featureFlags: {
          'Homework': true,
          'Quiz': true,
          'Stories': true,
          'AI Assistant': true,
          'Live Classes': false,
          'Downloads': true,
          'Library': true,
          'Attendance': true,
        },
      ),
    );

    _institutes.add(
      Institute(
        id: 'inst_dav',
        name: 'DAV Public School Patna',
        logoUrl: '',
        primaryColorHex: '4A154B', // Purple
        secondaryColorHex: 'FFC107', // Amber
        contactEmail: 'contact@davpatna.edu.in',
        contactPhone: '+919876543220',
        featureFlags: {
          'Homework': true,
          'Quiz': false,
          'Stories': true,
          'AI Assistant': false,
          'Live Classes': false,
          'Downloads': true,
          'Library': true,
          'Attendance': true,
        },
      ),
    );

    // Seed default audit logs
    _auditLogs.addAll([
      AuditLog(
        id: 'log_001',
        operatorName: 'Super Admin Director',
        operatorRole: 'Super Admin',
        actionType: 'Login',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        description: 'Super Admin logged in from Windows device.',
        instituteId: 'inst_akh',
      ),
      AuditLog(
        id: 'log_002',
        operatorName: 'Ms. Anjali Verma',
        operatorRole: 'Teacher',
        actionType: 'Upload',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        description: 'Uploaded equivalent fractions PDF notes to CBSE Class 5 library.',
        instituteId: 'inst_akh',
      )
    ]);
  }

  // Active branding properties
  Institute get activeInstitute => _institutes.firstWhere(
        (i) => i.id == _activeInstituteId,
        orElse: () => _institutes.first,
      );

  // Super Admin Control APIs
  void createInstitute(Institute inst) {
    _institutes.add(inst);
    notifyListeners();
  }

  void suspendInstitute(String id) {
    final idx = _institutes.indexWhere((i) => i.id == id);
    if (idx != -1) {
      _institutes[idx] = _institutes[idx].copyWith(status: 'Suspended');
      notifyListeners();
    }
  }

  void activateInstitute(String id) {
    final idx = _institutes.indexWhere((i) => i.id == id);
    if (idx != -1) {
      _institutes[idx] = _institutes[idx].copyWith(status: 'Active');
      notifyListeners();
    }
  }

  void deleteInstitute(String id) {
    _institutes.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  // Branch Operations
  void createBranch(String name, String address) {
    _branchesList.add({
      'id': 'branch_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'address': address,
      'studentCount': 0,
      'teacherCount': 0,
    });
    notifyListeners();
  }

  // Feature flag toggle API
  void toggleFeatureFlag(String feature, bool value) {
    final activeInst = activeInstitute;
    final Map<String, bool> updatedFlags = Map<String, bool>.from(activeInst.featureFlags);
    updatedFlags[feature] = value;
    
    final idx = _institutes.indexWhere((i) => i.id == _activeInstituteId);
    if (idx != -1) {
      _institutes[idx] = _institutes[idx].copyWith(featureFlags: updatedFlags);
      notifyListeners();
    }
  }

  // Check feature flag
  bool isFeatureEnabled(String feature) {
    return activeInstitute.featureFlags[feature] ?? true;
  }

  // Logger Operations
  void logAction(String operator, String role, String type, String desc) {
    final log = AuditLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      operatorName: operator,
      operatorRole: role,
      actionType: type,
      timestamp: DateTime.now(),
      description: desc,
      instituteId: _activeInstituteId,
    );
    _auditLogs.insert(0, log);
    notifyListeners();
  }

  // Backup Operations
  void triggerManualBackup() {
    _backupHistory.insert(0, {
      'id': 'bak_${DateTime.now().millisecondsSinceEpoch}',
      'date': DateTime.now().toString().substring(0, 19),
      'type': 'Manual Cloud Backup',
      'size': '4.6 MB',
      'status': 'Completed',
    });
    notifyListeners();
  }

  void restoreBackup(String backupId) {
    // Mock restore trigger
    logAction('System Operator', 'Admin', 'Settings', 'Restored system database backup $backupId.');
  }

  // Language API
  void switchLanguage(String lang) {
    _currentLanguage = lang;
    notifyListeners();
  }
}
