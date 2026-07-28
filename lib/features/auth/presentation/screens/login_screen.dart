import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../../dashboard/presentation/screens/main_navigation_screen.dart';
import '../../../web_panel/presentation/screens/admin_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      final formattedPhone = phone.startsWith('+') ? phone : '+91$phone';
      Provider.of<AuthViewModel>(context, listen: false).sendOtp(formattedPhone);
    }
  }

  void _onVerifyOtp() async {
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final smsCode = _otpController.text.trim();
    if (smsCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.valEnterValidOtp)),
      );
      return;
    }
    
    final success = await authVm.verifyOtp(smsCode);
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } else if (mounted && authVm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authVm.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withOpacity(isDark ? 0.15 : 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryOrange.withOpacity(isDark ? 0.15 : 0.08),
              ),
            ),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
                        ),
                      ).animate().fade(duration: 500.ms).scale(duration: 500.ms),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        AppStrings.appName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBlue,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        authVm.codeSent ? 'Enter code sent to your phone' : 'Sign in to access your portal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Input Forms in GlassContainer
                      GlassContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!authVm.codeSent) ...[
                              // Phone number input
                              CustomTextField(
                                controller: _phoneController,
                                labelText: 'Mobile Number',
                                hintText: 'Enter 10-digit number',
                                prefixIcon: Icons.phone_android_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return AppStrings.valEnterPhone;
                                  }
                                  if (val.trim().length < 10) {
                                    return AppStrings.valEnterValidPhone;
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Remember Me / Session persistence toggle
                              Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: authVm.rememberMe,
                                      activeColor: AppColors.primaryBlue,
                                      onChanged: (val) {
                                        if (val != null) {
                                          authVm.toggleRememberMe(val);
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Remember Me',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              CustomButton(
                                text: 'Send Verification Code',
                                isLoading: authVm.isLoading,
                                onPressed: _onSendOtp,
                              ),
                            ] else ...[
                              // OTP code verification input
                              CustomTextField(
                                controller: _otpController,
                                labelText: 'Verification Code (OTP)',
                                hintText: 'Enter 6-digit code',
                                prefixIcon: Icons.lock_outline,
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return AppStrings.valEnterOtp;
                                  }
                                  if (val.trim().length != 6) {
                                    return AppStrings.valEnterValidOtp;
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 24),
                              
                              CustomButton(
                                text: 'Verify & Login',
                                isLoading: authVm.isLoading,
                                onPressed: _onVerifyOtp,
                              ),
                              
                              const SizedBox(height: 12),
                              
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    authVm.logout(); // reset flow
                                  },
                                  child: const Text(
                                    'Change Phone Number',
                                    style: TextStyle(color: AppColors.secondaryOrange),
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ).animate().slideY(begin: 0.1, end: 0.0, duration: 400.ms),
                      
                      const SizedBox(height: 24),
                      
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                            );
                          },
                          child: const Text(
                            'Administrative / Staff Portal',
                            style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Bottom help / demo info
                      if (authVm.errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.error.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.error),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authVm.errorMessage!,
                                  style: const TextStyle(color: AppColors.error, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ).animate().shake(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
