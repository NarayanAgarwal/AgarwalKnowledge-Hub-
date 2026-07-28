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
  });

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
    );
  }
}
