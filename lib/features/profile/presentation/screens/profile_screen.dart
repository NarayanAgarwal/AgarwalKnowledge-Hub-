import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import '../../../../core/constants/app_colors.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import '../../../../core/models/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _pickImageFromGallery(BuildContext context, AuthViewModel authVm, UserProfile user) {
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((e) async {
            final base64Data = reader.result as String;
            final updated = user.copyWith(profilePhotoUrl: base64Data);
            await authVm.completeProfile(updated);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile photo updated successfully!')),
              );
            }
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gallery picker is supported on Web. Please paste a Photo URL on native.')),
      );
    }
  }

  void _showEditProfileDialog(BuildContext context, AuthViewModel authVm, UserProfile user) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final addressController = TextEditingController(text: user.address);
    final parentNameController = TextEditingController(text: user.parentName);
    final parentPhoneController = TextEditingController(text: user.parentMobile);
    final photoUrlController = TextEditingController(text: user.profilePhotoUrl);
    final classController = TextEditingController(text: user.userClass);
    final rollController = TextEditingController(text: user.rollNumber);
    final dobController = TextEditingController(text: user.dob);
    final emergencyController = TextEditingController(text: user.emergencyContact);
    String selectedGender = user.gender.isNotEmpty ? user.gender : 'Male';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Profile Details', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Full Name'),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: classController,
                        decoration: const InputDecoration(labelText: 'Class (e.g. Class 3, LKG)'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: rollController,
                        decoration: const InputDecoration(labelText: 'Roll Number'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: ['Male', 'Female', 'Other'].contains(selectedGender) ? selectedGender : 'Male',
                        decoration: const InputDecoration(labelText: 'Gender'),
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(value: 'Female', child: Text('Female')),
                          DropdownMenuItem(value: 'Other', child: Text('Other')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedGender = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: dobController,
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth (YYYY-MM-DD)',
                          suffixIcon: Icon(Icons.calendar_today, size: 16),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().subtract(const Duration(days: 3650)),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setDialogState(() {
                              dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email Address'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: parentNameController,
                        decoration: const InputDecoration(labelText: 'Parent Name'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: parentPhoneController,
                        decoration: const InputDecoration(labelText: 'Parent Mobile'),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emergencyController,
                        decoration: const InputDecoration(labelText: 'Emergency Contact'),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: photoUrlController,
                              decoration: const InputDecoration(labelText: 'Profile Photo URL'),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_library_outlined, color: AppColors.primaryBlue),
                            tooltip: 'Upload from Gallery',
                            onPressed: () {
                              _pickImageFromGallery(context, authVm, user);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final updated = user.copyWith(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        address: addressController.text.trim(),
                        parentName: parentNameController.text.trim(),
                        parentMobile: parentPhoneController.text.trim(),
                        profilePhotoUrl: photoUrlController.text.trim(),
                        userClass: classController.text.trim(),
                        rollNumber: rollController.text.trim(),
                        dob: dobController.text.trim(),
                        gender: selectedGender,
                        emergencyContact: emergencyController.text.trim(),
                      );
                      await authVm.completeProfile(updated);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile updated successfully!')),
                        );
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 22),
                      onPressed: () => _showEditProfileDialog(context, authVm, user),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _pickImageFromGallery(context, authVm, user),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white24,
                          child: CircleAvatar(
                            radius: 46,
                            backgroundColor: Colors.white,
                            child: user.profilePhotoUrl.isNotEmpty
                                ? ClipOval(child: Image.network(user.profilePhotoUrl, fit: BoxFit.cover, errorBuilder: (c, o, s) => const Icon(Icons.person, size: 50, color: AppColors.primaryBlue)))
                                : const Icon(Icons.person, size: 50, color: AppColors.primaryBlue),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryOrange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
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
