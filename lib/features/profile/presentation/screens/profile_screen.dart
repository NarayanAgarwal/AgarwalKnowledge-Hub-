import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final user = authVm.userProfile;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Card (Header)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white24,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: Colors.white,
                      child: user.profilePhotoUrl.isNotEmpty
                          ? ClipOval(child: Image.network(user.profilePhotoUrl, fit: BoxFit.cover))
                          : const Icon(Icons.person, size: 50, color: AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name.isNotEmpty ? user.name : 'Student Name',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${user.role} | Class: ${user.userClass}',
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Detail Fields
            _buildSectionTitle('Academic Details'),
            _buildDetailCard(isDark, [
              _buildDetailItem('Admission No.', user.admissionNumber.isNotEmpty ? user.admissionNumber : 'ADM-2026-003'),
              _buildDetailItem('Roll Number', user.rollNumber.isNotEmpty ? user.rollNumber : '23'),
              _buildDetailItem('School Name', user.school.isNotEmpty ? user.school : 'Agarwal Knowledge Hub'),
            ]),
            
            const SizedBox(height: 16),
            
            _buildSectionTitle('Personal & Contact Info'),
            _buildDetailCard(isDark, [
              _buildDetailItem('Phone Number', user.phone),
              _buildDetailItem('Email Address', user.email.isNotEmpty ? user.email : 'not-provided@email.com'),
              _buildDetailItem('Gender', user.gender.isNotEmpty ? user.gender : 'Male'),
              _buildDetailItem('Date of Birth', user.dob.isNotEmpty ? user.dob : '2015-04-12'),
              _buildDetailItem('Address', user.address.isNotEmpty ? user.address : 'Patna, Bihar'),
            ]),
            
            const SizedBox(height: 16),
            
            _buildSectionTitle('Parent Details'),
            _buildDetailCard(isDark, [
              _buildDetailItem('Parent Name', user.parentName.isNotEmpty ? user.parentName : 'Suresh Agarwal'),
              _buildDetailItem('Parent Mobile', user.parentMobile.isNotEmpty ? user.parentMobile : '+919876543220'),
              _buildDetailItem('Emergency Contact', user.emergencyContact.isNotEmpty ? user.emergencyContact : '+919876543221'),
            ]),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryBlue),
        ),
      ),
    );
  }

  Widget _buildDetailCard(bool isDark, List<Widget> children) {
    return Card(
      color: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
