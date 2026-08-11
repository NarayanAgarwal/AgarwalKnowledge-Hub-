import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import '../../../dashboard/presentation/screens/main_navigation_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../web_panel/presentation/screens/web_dashboard_shell.dart';
import '../../../attendance/presentation/screens/attendance_dashboard_screen.dart';
import '../../../../core/services/academic_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    
    try {
      await authVm.initializationFuture;
    } catch (e) {
      debugPrint("Error loading initialization session: $e");
    }
    
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    
    final params = Uri.base.queryParameters;
    if (authVm.userProfile != null) {
      if (params['action'] == 'qr_attendance') {
        final token = params['token'];
        final classScope = params['class'] ?? 'All Classes';
        if (token != null) {
          final acadProvider = Provider.of<AcademicProvider>(context, listen: false);
          acadProvider.updateQrConfig(
            token: token,
            classScope: classScope,
            secondsRemaining: 86400,
          );
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AttendanceDashboardScreen()),
        );
      } else {
        final role = authVm.userProfile!.role;
        if (role == AppStrings.roleSuperAdmin || role == AppStrings.roleAdmin || role == AppStrings.roleTeacher) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WebDashboardShell()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
          );
        }
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.darkBackground, const Color(0xFF1E3C72).withOpacity(0.2)]
                : [AppColors.lightBackground, const Color(0xFFE2E8F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    AppAssets.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  .animate()
                  .fade(duration: 800.ms)
                  .scale(delay: 200.ms, duration: 800.ms, curve: Curves.easeOutBack),
              
              const SizedBox(height: 24),
              
              // App Title
              Text(
                AppStrings.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBlue,
                ),
              )
                  .animate()
                  .fade(delay: 500.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0.0, curve: Curves.easeOutQuad),
              
              const SizedBox(height: 12),
              
              // Subtitle
              Text(
                'Nurturing Minds, Empowering Future',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              )
                  .animate()
                  .fade(delay: 800.ms, duration: 600.ms),
              
              const SizedBox(height: 60),
              
              // Loading Indicator
              const CircularProgressIndicator(
                color: AppColors.secondaryOrange,
                strokeWidth: 3,
              )
                  .animate()
                  .fade(delay: 1000.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
