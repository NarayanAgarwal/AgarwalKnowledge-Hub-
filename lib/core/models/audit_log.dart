class AuditLog {
  final String id;
  final String operatorName;
  final String operatorRole;
  final String actionType; // 'Login' | 'Logout' | 'Upload' | 'Delete' | 'Settings'
  final DateTime timestamp;
  final String description;
  final String instituteId;

  AuditLog({
    required this.id,
    required this.operatorName,
    required this.operatorRole,
    required this.actionType,
    required this.timestamp,
    required this.description,
    required this.instituteId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'operatorName': operatorName,
      'operatorRole': operatorRole,
      'actionType': actionType,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'instituteId': instituteId,
    };
  }

  factory AuditLog.fromMap(Map<String, dynamic> map) {
    return AuditLog(
      id: map['id'] ?? '',
      operatorName: map['operatorName'] ?? '',
      operatorRole: map['operatorRole'] ?? '',
      actionType: map['actionType'] ?? 'Settings',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      description: map['description'] ?? '',
      instituteId: map['instituteId'] ?? '',
    );
  }
}
