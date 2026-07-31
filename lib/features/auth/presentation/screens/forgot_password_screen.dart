import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../../dashboard/presentation/screens/main_navigation_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isOtpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    
    // First verify if the phone number is registered
    final isRegistered = await authVm.isPhoneRegistered(phone);
    if (!isRegistered && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This mobile number is not registered. Please register first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await authVm.sendOtp(phone.startsWith('+91') ? phone : '+91$phone');
    if (mounted) {
      if (authVm.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authVm.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          _isOtpSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset OTP sent successfully! 💬'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _onResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final phone = _phoneController.text.trim();
    final cleanPhone = phone.startsWith('+91') ? phone : '+91$phone';

    // Step 1: Verify OTP
    final otpVerified = await authVm.verifyOtp(_otpController.text.trim());
    if (!otpVerified && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authVm.errorMessage ?? 'Incorrect OTP entered.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Step 2: Update Password in database
    final newPassword = _passwordController.text;
    final updated = await authVm.resetPasswordWithOtp(cleanPhone, newPassword);

    if (updated && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully! Logging you in... 🔐🎉'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate to dashboard directly (since verifyOtp automatically logged them in)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authVm.errorMessage ?? 'Failed to update password.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password 🔐', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.darkBackground, const Color(0xFF1E3C72).withOpacity(0.2)]
                : [const Color(0xFFE0F7FA), const Color(0xFFFFECEF)], // Pastel cyan and red playroom gradients
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark ? Colors.white10 : AppColors.primaryBlue.withOpacity(0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.12),
                        offset: const Offset(0, 10),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          _isOtpSent ? 'Enter Reset Details 🔑' : 'Verify Mobile Number 📱',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Step 1: Mobile Number Input
                      const Text('Registered Mobile Number 📱', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: _phoneController,
                        labelText: 'Mobile Number',
                        hintText: 'Enter mobile number',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        enabled: !_isOtpSent,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Please enter mobile number';
                          if (val.trim().length < 10) return 'Enter a valid 10-digit number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      if (!_isOtpSent) ...[
                        // Send OTP Button
                        CustomButton(
                          text: 'Send Reset OTP 💬',
                          isLoading: authVm.isLoading,
                          onPressed: _onSendOtp,
                        ),
                      ] else ...[
                        // Step 2: OTP & New Password Inputs
                        const Text('Enter 6-Digit OTP 💬', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: _otpController,
                          labelText: 'Reset OTP Code',
                          hintText: 'Enter OTP code',
                          prefixIcon: Icons.sms_outlined,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Please enter OTP';
                            if (val.trim().length < 6) return 'OTP must be 6 digits';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        const Text('New Password 🔑', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: _passwordController,
                          labelText: 'New Password',
                          hintText: 'Enter new password',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Please set a password';
                            if (val.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        const Text('Confirm New Password 🔑', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          labelText: 'Confirm Password',
                          hintText: 'Confirm new password',
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Please confirm your password';
                            if (val != _passwordController.text) return 'Passwords do not match';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Reset & Login Button
                        CustomButton(
                          text: 'Verify & Reset Password 🚀',
                          isLoading: authVm.isLoading,
                          onPressed: _onResetPassword,
                        ),

                        const SizedBox(height: 14),

                        // Resend / Back Link
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isOtpSent = false;
                                _otpController.clear();
                              });
                            },
                            child: const Text(
                              'Change Mobile Number',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
