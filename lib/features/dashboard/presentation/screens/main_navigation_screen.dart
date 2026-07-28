import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'dashboard_screen.dart';
import '../../../library/presentation/screens/digital_library_screen.dart';
import '../../../homework/presentation/screens/homework_screen.dart';
import '../../../notice/presentation/screens/notice_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../classes/presentation/screens/class_selection_screen.dart';
import '../../../doubt_support/presentation/screens/doubt_support_screen.dart';
import '../../../downloads/presentation/screens/downloads_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../attendance/presentation/screens/attendance_dashboard_screen.dart';
import '../../../homework/presentation/screens/homework_evaluation_screen.dart';
import '../../../quiz/presentation/screens/report_card_screen.dart';
import 'academic_calendar_screen.dart';
import '../../../web_panel/presentation/screens/super_admin_master_panel.dart';
import '../../../web_panel/presentation/screens/institute_branding_screen.dart';
import '../../../settings/presentation/screens/enterprise_settings_panel.dart';
import '../../../../core/models/user_profile.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const DigitalLibraryScreen(),
    const HomeworkScreen(),
    const NoticeScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVm = Provider.of<AuthViewModel>(context, listen: false);
      final dashVm = Provider.of<DashboardViewModel>(context, listen: false);
      if (authVm.userProfile != null) {
        dashVm.loadDashboardData(
          authVm.userProfile!.userClass,
          authVm.userProfile!.uid,
        );
      }
    });
  }

  void _onLogout() async {
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    await authVm.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final user = authVm.userProfile;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) {
      return const LoginScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? AppStrings.appName : _getTabTitle(_currentIndex)),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent_outlined, color: AppColors.secondaryOrange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DoubtSupportScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildSideDrawer(context, user, isDark),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          indicatorColor: AppColors.primaryBlue.withOpacity(0.15),
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined, color: AppColors.primaryBlue),
              selectedIcon: Icon(Icons.grid_view, color: AppColors.primaryBlue),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined, color: AppColors.primaryBlue),
              selectedIcon: Icon(Icons.menu_book, color: AppColors.primaryBlue),
              label: 'Library',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined, color: AppColors.primaryBlue),
              selectedIcon: Icon(Icons.assignment, color: AppColors.primaryBlue),
              label: 'Homework',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_active_outlined, color: AppColors.primaryBlue),
              selectedIcon: Icon(Icons.notifications_active, color: AppColors.primaryBlue),
              label: 'Notice',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: AppColors.primaryBlue),
              selectedIcon: Icon(Icons.person, color: AppColors.primaryBlue),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 1:
        return 'Library Catalog';
      case 2:
        return 'Daily Homework';
      case 3:
        return 'School Notices';
      case 4:
        return 'Student Profile';
      default:
        return AppStrings.appName;
    }
  }

  Widget _buildSideDrawer(BuildContext context, UserProfile user, bool isDark) {
    return Drawer(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: user.profilePhotoUrl.isNotEmpty
                  ? ClipOval(child: Image.network(user.profilePhotoUrl, fit: BoxFit.cover))
                  : const Icon(Icons.person, size: 40, color: AppColors.primaryBlue),
            ),
            accountName: Text(
              user.name.isNotEmpty ? user.name : 'Welcome Student',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(
              '${user.role} | ${user.phone}',
              style: TextStyle(color: Colors.white.withOpacity(0.85)),
            ),
          ),
          
          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 0);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.class_outlined,
                  title: 'Academic Classes',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ClassSelectionScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.menu_book_outlined,
                  title: 'Library Hub',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 1);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.assignment_outlined,
                  title: 'Homework Tasks',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 2);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.notifications_active_outlined,
                  title: 'Notice Board',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 3);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'AI Doubt Support',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DoubtSupportScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.download_for_offline_outlined,
                  title: 'Offline Downloads',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DownloadsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.qr_code_scanner_outlined,
                  title: 'Attendance Terminal',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AttendanceDashboardScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'Academic Calendar',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AcademicCalendarScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.grade_outlined,
                  title: 'Performance Report',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReportCardScreen()),
                    );
                  },
                ),
                if (user.role == 'Teacher' || user.role == 'Admin' || user.role == 'Super Admin')
                  _buildDrawerItem(
                    icon: Icons.rate_review_outlined,
                    title: 'Homework Evaluation',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeworkEvaluationScreen()),
                      );
                    },
                  ),
                if (user.role == 'Super Admin')
                  _buildDrawerItem(
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Super Admin Master Controls',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SuperAdminMasterPanel()),
                      );
                    },
                  ),
                if (user.role == 'Super Admin' || user.role == 'Admin') ...[
                  _buildDrawerItem(
                    icon: Icons.color_lens_outlined,
                    title: 'Institute Branding',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InstituteBrandingScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.tune_outlined,
                    title: 'Enterprise Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EnterpriseSettingsPanel()),
                      );
                    },
                  ),
                ],
                const Divider(),
                
                _buildDrawerItem(
                  icon: Icons.logout_outlined,
                  title: 'Logout Portal',
                  iconColor: AppColors.secondaryOrange,
                  onTap: () {
                    Navigator.pop(context);
                    _onLogout();
                  },
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Agarwal Knowledge Hub v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primaryBlue),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      onTap: onTap,
    );
  }
}
