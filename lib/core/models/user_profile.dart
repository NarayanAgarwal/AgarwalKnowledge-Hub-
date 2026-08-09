import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String role; // 'Super Admin', 'Admin', 'Teacher', 'Student', 'Parent'
  final String name;
  final String phone;
  final String email;
  final String address;
  final String userClass; // 'Class 1', 'Class 2', etc. (applicable for Students)
  final String rollNumber; // (applicable for Students)
  final String gender;
  final String dob;
  final String admissionNumber;
  final String school;
  final String parentName; // (applicable for Students)
  final String parentMobile; // (applicable for Students/Parents)
  final String emergencyContact;
  final String profilePhotoUrl;
  final DateTime createdDate;
  final DateTime lastLogin;
  final bool isOnline;
  final DateTime lastActive;
  final bool isBlocked;
  final String statusNote; // 'Active', 'On Leave', 'Teaching', 'Suspended'

  UserProfile({
    required this.uid,
    required this.role,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.userClass,
    required this.rollNumber,
    required this.gender,
    required this.dob,
    required this.admissionNumber,
    required this.school,
    required this.parentName,
    required this.parentMobile,
    required this.emergencyContact,
    required this.profilePhotoUrl,
    required this.createdDate,
    required this.lastLogin,
    this.isOnline = false,
    DateTime? lastActive,
    this.isBlocked = false,
    this.statusNote = 'Active',
  }) : lastActive = lastActive ?? createdDate;

  factory UserProfile.fromFirestore(Map<String, dynamic> data, String id) {
    return UserProfile(
      uid: id,
      role: data['role'] ?? 'Student',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      userClass: data['class'] ?? '',
      rollNumber: data['rollNumber'] ?? '',
      gender: data['gender'] ?? '',
      dob: data['dob'] ?? '',
      admissionNumber: data['admissionNumber'] ?? '',
      school: data['school'] ?? 'Agarwal Knowledge Hub',
      parentName: data['parentName'] ?? '',
      parentMobile: data['parentMobile'] ?? '',
      emergencyContact: data['emergencyContact'] ?? '',
      profilePhotoUrl: data['profilePhotoUrl'] ?? '',
      createdDate: (data['createdDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isOnline: data['isOnline'] ?? false,
      lastActive: (data['lastActive'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isBlocked: data['isBlocked'] ?? false,
      statusNote: data['statusNote'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'role': role,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'class': userClass,
      'rollNumber': rollNumber,
      'gender': gender,
      'dob': dob,
      'admissionNumber': admissionNumber,
      'school': school,
      'parentName': parentName,
      'parentMobile': parentMobile,
      'emergencyContact': emergencyContact,
      'profilePhotoUrl': profilePhotoUrl,
      'createdDate': createdDate.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'isOnline': isOnline,
      'lastActive': lastActive.toIso8601String(),
      'isBlocked': isBlocked,
      'statusNote': statusNote,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] ?? '',
      role: json['role'] ?? 'Student',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      userClass: json['class'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      admissionNumber: json['admissionNumber'] ?? '',
      school: json['school'] ?? 'Agarwal Knowledge Hub',
      parentName: json['parentName'] ?? '',
      parentMobile: json['parentMobile'] ?? '',
      emergencyContact: json['emergencyContact'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
      createdDate: DateTime.parse(json['createdDate'] ?? DateTime.now().toIso8601String()),
      lastLogin: DateTime.parse(json['lastLogin'] ?? DateTime.now().toIso8601String()),
      isOnline: json['isOnline'] ?? false,
      lastActive: json['lastActive'] != null ? DateTime.parse(json['lastActive']) : DateTime.now(),
      isBlocked: json['isBlocked'] ?? false,
      statusNote: json['statusNote'] ?? 'Active',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'role': role,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'class': userClass,
      'rollNumber': rollNumber,
      'gender': gender,
      'dob': dob,
      'admissionNumber': admissionNumber,
      'school': school,
      'parentName': parentName,
      'parentMobile': parentMobile,
      'emergencyContact': emergencyContact,
      'profilePhotoUrl': profilePhotoUrl,
      'createdDate': Timestamp.fromDate(createdDate),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'isOnline': isOnline,
      'lastActive': Timestamp.fromDate(lastActive),
      'isBlocked': isBlocked,
      'statusNote': statusNote,
    };
  }

  UserProfile copyWith({
    String? role,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? userClass,
    String? rollNumber,
    String? gender,
    String? dob,
    String? admissionNumber,
    String? school,
    String? parentName,
    String? parentMobile,
    String? emergencyContact,
    String? profilePhotoUrl,
    DateTime? createdDate,
    DateTime? lastLogin,
    bool? isOnline,
    DateTime? lastActive,
    bool? isBlocked,
    String? statusNote,
  }) {
    return UserProfile(
      uid: uid,
      role: role ?? this.role,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      userClass: userClass ?? this.userClass,
      rollNumber: rollNumber ?? this.rollNumber,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      admissionNumber: admissionNumber ?? this.admissionNumber,
      school: school ?? this.school,
      parentName: parentName ?? this.parentName,
      parentMobile: parentMobile ?? this.parentMobile,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      createdDate: createdDate ?? this.createdDate,
      lastLogin: lastLogin ?? this.lastLogin,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      isBlocked: isBlocked ?? this.isBlocked,
      statusNote: statusNote ?? this.statusNote,
    );
  }
}
