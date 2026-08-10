import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import 'web_dashboard_shell.dart';
import '../../../../core/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  String _selectedRole = AppStrings.roleSuperAdmin;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final String email = _emailController.text.trim().toLowerCase();
      final String password = _passwordController.text.trim();
      final authVm = Provider.of<AuthViewModel>(context, listen: false);

      // 1. Strict Email Format Verification (must contain @ and valid domain like .com)
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(email)) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Access Denied: Please enter a valid Email address containing @ and .com'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // 2. Strict Role Credential Checks
      if (_selectedRole == AppStrings.roleSuperAdmin || email == 'abhayff754@gmail.com') {
        if (email != 'abhayff754@gmail.com') {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Access Denied: Super Admin login email must be abhayff754@gmail.com'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        if (password != 'MoMDaD754') {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Access Denied: Incorrect Super Admin Password! Required: MoMDaD754'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      if (_selectedRole == AppStrings.roleTeacher) {
        if (password != 'AgarwalHub@') {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Access Denied: Incorrect Teacher Password! Required: AgarwalHub@'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      UserProfile? profile;

      try {
        if (authVm.isMockMode) {
          await Future.delayed(const Duration(milliseconds: 800));
          
          if (email == 'abhayff754@gmail.com' && password == 'MoMDaD754') {
            profile = UserProfile(
              uid: "web_admin_123",
              role: AppStrings.roleSuperAdmin,
              name: "Director Narayan Agarwal",
              phone: "+919876543299",
              email: email,
              address: "Mithapur, Patna",
              userClass: "",
              rollNumber: "",
              gender: "Male",
              dob: "1978-05-15",
              admissionNumber: "ADM-AKH-001",
              school: "Agarwal Knowledge Hub",
              parentName: "",
              parentMobile: "",
              emergencyContact: "",
              profilePhotoUrl: "",
              createdDate: DateTime.now(),
              lastLogin: DateTime.now(),
            );
          } else if (email == 'principal@agarwal.com' && password == '123456' && _selectedRole == AppStrings.roleAdmin) {
            profile = UserProfile(
              uid: "web_principal_123",
              role: AppStrings.roleAdmin,
              name: "Principal Suresh Prasad",
              phone: "+919876543298",
              email: email,
              address: "Kankarbagh, Patna",
              userClass: "",
              rollNumber: "",
              gender: "Male",
              dob: "1972-04-10",
              admissionNumber: "PRN-AKH-002",
              school: "Agarwal Knowledge Hub",
              parentName: "",
              parentMobile: "",
              emergencyContact: "",
              profilePhotoUrl: "",
              createdDate: DateTime.now(),
              lastLogin: DateTime.now(),
            );
          } else if (_selectedRole == AppStrings.roleTeacher && password == 'AgarwalHub@') {
            profile = UserProfile(
              uid: "web_teacher_${email.hashCode.abs()}",
              role: AppStrings.roleTeacher,
              name: "Teacher (${email.split('@').first})",
              phone: "+919876543222",
              email: email,
              address: "Patna",
              userClass: "",
              rollNumber: "",
              gender: "Female",
              dob: "1994-04-12",
              admissionNumber: "TCH-${email.hashCode.abs().toString().substring(0, 4)}",
              school: "Agarwal Knowledge Hub",
              parentName: "",
              parentMobile: "",
              emergencyContact: "",
              profilePhotoUrl: "",
              createdDate: DateTime.now(),
              lastLogin: DateTime.now(),
            );
          } else {
            // Unrecognized credentials in mock mode -> reject completely!
            profile = null;
          }
        } else {
          // Live Firebase Mode: search in Firestore users collection for matching email & password
          if (email == 'abhayff754@gmail.com' && password == 'MoMDaD754') {
            profile = UserProfile(
              uid: "web_admin_123",
              role: AppStrings.roleSuperAdmin,
              name: "Director Narayan Agarwal",
              phone: "+919876543299",
              email: email,
              address: "Mithapur, Patna",
              userClass: "",
              rollNumber: "",
              gender: "Male",
              dob: "1978-05-15",
              admissionNumber: "ADM-AKH-001",
              school: "Agarwal Knowledge Hub",
              parentName: "",
              parentMobile: "",
              emergencyContact: "",
              profilePhotoUrl: "",
              createdDate: DateTime.now(),
              lastLogin: DateTime.now(),
            );
            // Save/sync profile document to Firestore to ensure consistency
            try {
              await FirebaseFirestore.instance
                  .collection(AppStrings.colUsers)
                  .doc(profile.uid)
                  .set(profile.toFirestore());
            } catch (e) {
              debugPrint("Warning: could not write admin profile: $e");
            }
          } else if (_selectedRole == AppStrings.roleTeacher && password == 'AgarwalHub@') {
            final query = await FirebaseFirestore.instance
                .collection(AppStrings.colUsers)
                .where('email', isEqualTo: email)
                .where('role', isEqualTo: AppStrings.roleTeacher)
                .limit(1)
                .get();

            if (query.docs.isNotEmpty) {
              final doc = query.docs.first;
              profile = UserProfile.fromFirestore(doc.data(), doc.id);
            } else {
              // Auto-create teacher profile on the fly in Firestore to allow successful login!
              final namePart = email.split('@').first;
              final capitalizedName = namePart.isNotEmpty 
                  ? (namePart[0].toUpperCase() + namePart.substring(1)) 
                  : "Teacher";
                  
              profile = UserProfile(
                uid: "web_teacher_${email.hashCode.abs()}",
                role: AppStrings.roleTeacher,
                name: capitalizedName,
                phone: "+919876543222",
                email: email,
                address: "Patna",
                userClass: "",
                rollNumber: "",
                gender: "Female",
                dob: "1994-04-12",
                admissionNumber: "TCH-${email.hashCode.abs().toString().substring(0, 4)}",
                school: "Agarwal Knowledge Hub",
                parentName: "",
                parentMobile: "",
                emergencyContact: "",
                profilePhotoUrl: "",
                createdDate: DateTime.now(),
                lastLogin: DateTime.now(),
              );
              try {
                await FirebaseFirestore.instance
                    .collection(AppStrings.colUsers)
                    .doc(profile.uid)
                    .set(profile.toFirestore());
              } catch (e) {
                debugPrint("Warning: could not write self teacher profile: $e");
              }
            }
          } else {
            final query = await FirebaseFirestore.instance
                .collection(AppStrings.colUsers)
                .where('email', isEqualTo: email)
                .where('password', isEqualTo: password)
                .limit(1)
                .get();

            if (query.docs.isNotEmpty) {
              final doc = query.docs.first;
              profile = UserProfile.fromFirestore(doc.data(), doc.id);
            }
          }
        }
      } catch (e) {
        debugPrint("Error authenticating admin user: $e");
      }

      setState(() => _isLoading = false);

      if (profile != null) {
        if (profile.role != _selectedRole && _selectedRole != AppStrings.roleStudent && _selectedRole != AppStrings.roleParent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Role Mismatch: Account role is "${profile.role}", but you selected "$_selectedRole".'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        await authVm.completeProfile(profile);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WebDashboardShell()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Access Denied: Invalid Email Address or Password! Login Rejected.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final bool isDesktop = width >= 900;

    return Scaffold(
      body: Row(
        children: [
          // Left Banner Area (Desktop only)
          if (isDesktop)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white24,
                          child: ClipOval(child: Image.asset(AppAssets.logo, fit: BoxFit.cover)),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          AppStrings.appName,
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Administration & Academic Portal Panel',
                          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.85)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          
          // Right Login Form Area
          Container(
            width: isDesktop ? 480 : width,
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isDesktop) ...[
                        Center(
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(AppAssets.logo),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            AppStrings.appName,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      const Text(
                        'Administrative Login',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please verify your portal access role credentials',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      
                      const SizedBox(height: 32),

                      // Role Dropdown
                      const Text('Access Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          borderRadius: BorderRadius.circular(16),
                          color: isDark ? AppColors.darkSurface : Colors.white,
                        ),
                        child: DropdownButton<String>(
                          value: _selectedRole,
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          items: [
                            AppStrings.roleSuperAdmin,
                            AppStrings.roleAdmin,
                            AppStrings.roleTeacher,
                            'Accountant',
                            AppStrings.roleStudent,
                            AppStrings.roleParent,
                          ].map((role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role == AppStrings.roleAdmin ? 'School Admin / Principal' : role),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedRole = val);
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email Address',
                        hintText: 'abhayff754@gmail.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return AppStrings.valRequiredField;
                          }
                          final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegExp.hasMatch(val.trim())) {
                            return 'Please enter a valid Gmail address (must contain @ and .com)';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Access Password',
                        hintText: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return AppStrings.valRequiredField;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      CustomButton(
                        text: 'Authenticate Access',
                        isLoading: _isLoading,
                        onPressed: _onLogin,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
