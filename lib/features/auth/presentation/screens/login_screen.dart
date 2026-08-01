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
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _otpFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _otpFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      final formattedPhone = phone.startsWith('+91') ? phone : '+91$phone';
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

  void _onLoginWithPassword() async {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      final password = _passwordController.text;
      final formattedPhone = phone.startsWith('+91') ? phone : '+91$phone';
      
      final authVm = Provider.of<AuthViewModel>(context, listen: false);
      final success = await authVm.loginWithPassword(formattedPhone, password);
      
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      } else if (mounted && authVm.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authVm.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                        authVm.codeSent
                            ? 'Enter code sent to your phone'
                            : (authVm.isOtpLoginMode ? 'Sign in using SMS Verification Code' : 'Sign in using Phone & Password'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      
                      if (authVm.isMockMode) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryOrange.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.secondaryOrange.withOpacity(0.3), width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.info_outline, color: AppColors.secondaryOrange, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Demo/Mock Mode is Active',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDark ? Colors.white : AppColors.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• Real SMS OTP will not be sent to your phone.\n'
                                '• To log in / verify OTP, use Mock OTP: 123456\n'
                                '• Default account: 9876543210 (Password: 123456)\n'
                                '• For new numbers: register first, then use OTP 123456.',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Toggle Login Mode Tab
                      if (!authVm.codeSent)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => authVm.toggleLoginMode(false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: !authVm.isOtpLoginMode
                                          ? (isDark ? AppColors.primaryBlue : Colors.white)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: !authVm.isOtpLoginMode && !isDark
                                          ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                                          : [],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Password Login',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: !authVm.isOtpLoginMode
                                              ? (isDark ? Colors.white : AppColors.primaryBlue)
                                              : (isDark ? Colors.white60 : Colors.grey[600]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => authVm.toggleLoginMode(true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: authVm.isOtpLoginMode
                                          ? (isDark ? AppColors.primaryBlue : Colors.white)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: authVm.isOtpLoginMode && !isDark
                                          ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                                          : [],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'OTP Login',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: authVm.isOtpLoginMode
                                              ? (isDark ? Colors.white : AppColors.primaryBlue)
                                              : (isDark ? Colors.white60 : Colors.grey[600]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Input Forms in GlassContainer
                      GlassContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!authVm.codeSent) ...[
                              // Phone number input
                              CustomTextField(
                                controller: _phoneController,
                                focusNode: _phoneFocusNode,
                                textInputAction: TextInputAction.next,
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
                              
                              if (!authVm.isOtpLoginMode) ...[
                                // Password Input
                                CustomTextField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _onLoginWithPassword(),
                                  labelText: 'Password',
                                  hintText: 'Enter password',
                                  prefixIcon: Icons.lock_outline,
                                  isPassword: true,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                // Forgot Password Link
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                                      );
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryBlue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

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
                                text: authVm.isOtpLoginMode ? 'Send Verification Code' : 'Login Securely 🚀',
                                isLoading: authVm.isLoading,
                                onPressed: authVm.isOtpLoginMode ? _onSendOtp : _onLoginWithPassword,
                              ),
                            ] else ...[
                              // OTP code verification input
                              CustomTextField(
                                controller: _otpController,
                                focusNode: _otpFocusNode,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _onVerifyOtp(),
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
                      
                      const SizedBox(height: 20),

                      // Register screen navigation link
                      if (!authVm.codeSent)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New Student? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                );
                              },
                              child: const Text(
                                'Register Here 🎒',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 16),
                      
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
                      
                      // Error display
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
