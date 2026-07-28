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
      
      // Simulate admin verification
      await Future.delayed(const Duration(seconds: 1.5));
      
      if (!mounted) return;
      
      // Seed details in AuthViewModel
      final authVm = Provider.of<AuthViewModel>(context, listen: false);
      final profile = UserProfile(
        uid: "web_admin_123",
        role: _selectedRole,
        name: "Director Agarwal",
        phone: "+919876543299",
        email: _emailController.text.trim(),
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

      await authVm.completeProfile(profile);

      setState(() => _isLoading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WebDashboardShell()),
      );
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
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.extrabold),
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
                          items: [AppStrings.roleSuperAdmin, AppStrings.roleAdmin, AppStrings.roleTeacher].map((role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
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
                        hintText: 'admin@agarwal.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return AppStrings.valRequiredField;
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
