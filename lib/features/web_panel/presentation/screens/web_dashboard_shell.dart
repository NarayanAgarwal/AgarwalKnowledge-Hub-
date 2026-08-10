import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import '../../viewmodels/web_panel_viewmodel.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/models/attendance.dart';
import '../../../../core/models/homework.dart';
import '../../../../core/models/note.dart';
import '../../../../core/models/notice.dart';
import '../../../../core/models/quiz.dart';
import '../../../../core/models/story.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

class WebDashboardShell extends StatefulWidget {
  const WebDashboardShell({super.key});

  @override
  State<WebDashboardShell> createState() => _WebDashboardShellState();
}

class _WebDashboardShellState extends State<WebDashboardShell> {
  int _selectedMenuIndex = 0;
  bool _isSidebarCollapsed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _getMenuItemsForRole(String role) {
    switch (role) {
      case 'Super Admin':
        return [
          {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
          {'title': 'Student Management', 'icon': Icons.people_outline},
          {'title': 'Teacher Management', 'icon': Icons.assignment_ind_outlined},
          {'title': 'Parent Management', 'icon': Icons.family_restroom_outlined},
          {'title': 'School & Branches', 'icon': Icons.business_outlined},
          {'title': 'Class & Subjects', 'icon': Icons.class_outlined},
          {'title': 'Section Management', 'icon': Icons.layers_outlined},
          {'title': 'Attendance', 'icon': Icons.calendar_today_outlined},
          {'title': 'Homework', 'icon': Icons.assignment_outlined},
          {'title': 'Quiz Builder', 'icon': Icons.quiz_outlined},
          {'title': 'Resource Library', 'icon': Icons.menu_book_outlined},
          {'title': 'Study With Play', 'icon': Icons.sports_esports_outlined},
          {'title': 'AI Learning', 'icon': Icons.psychology_outlined},
          {'title': 'Story Expire', 'icon': Icons.history_toggle_off_outlined},
          {'title': 'Library Settings', 'icon': Icons.local_library_outlined},
          {'title': 'Events & Gallery', 'icon': Icons.event_note_outlined},
          {'title': 'Certificates', 'icon': Icons.card_membership_outlined},
          {'title': 'Fee Management', 'icon': Icons.account_balance_wallet_outlined},
          {'title': 'Push Alerts', 'icon': Icons.notifications_active_outlined},
          {'title': 'Reports & Analytics', 'icon': Icons.analytics_outlined},
          {'title': 'User & Role Mgmt', 'icon': Icons.admin_panel_settings_outlined},
          {'title': 'System Settings', 'icon': Icons.settings_outlined},
          {'title': 'Database & Backup', 'icon': Icons.storage_outlined},
          {'title': 'Firebase Settings', 'icon': Icons.cloud_queue_outlined},
          {'title': 'Subscription Admin', 'icon': Icons.card_giftcard_outlined},
          {'title': 'Payment Settings', 'icon': Icons.payment_outlined},
          {'title': 'Ads Settings', 'icon': Icons.ad_units_outlined},
          {'title': 'Contact & Support', 'icon': Icons.support_agent_outlined},
          {'title': 'Activity Logs', 'icon': Icons.list_alt_outlined},
        ];
      case 'Admin': // School Admin / Principal
        return [
          {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
          {'title': 'Student Management', 'icon': Icons.people_outline},
          {'title': 'Teacher Management', 'icon': Icons.assignment_ind_outlined},
          {'title': 'Parent Management', 'icon': Icons.family_restroom_outlined},
          {'title': 'Class & Subjects', 'icon': Icons.class_outlined},
          {'title': 'Section Management', 'icon': Icons.layers_outlined},
          {'title': 'Attendance', 'icon': Icons.calendar_today_outlined},
          {'title': 'Homework', 'icon': Icons.assignment_outlined},
          {'title': 'Quiz Builder', 'icon': Icons.quiz_outlined},
          {'title': 'Resource Library', 'icon': Icons.menu_book_outlined},
          {'title': 'Events & Gallery', 'icon': Icons.event_note_outlined},
          {'title': 'Certificates', 'icon': Icons.card_membership_outlined},
          {'title': 'Fee Collection', 'icon': Icons.account_balance_wallet_outlined},
          {'title': 'Push Alerts', 'icon': Icons.notifications_active_outlined},
          {'title': 'Reports & Analytics', 'icon': Icons.analytics_outlined},
        ];
      case 'Teacher':
        return [
          {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
          {'title': 'Attendance', 'icon': Icons.calendar_today_outlined},
          {'title': 'Homework', 'icon': Icons.assignment_outlined},
          {'title': 'Assignments', 'icon': Icons.assignment_turned_in_outlined},
          {'title': 'Quiz Builder', 'icon': Icons.quiz_outlined},
          {'title': 'Resource Library', 'icon': Icons.menu_book_outlined},
          {'title': 'Study With Play', 'icon': Icons.sports_esports_outlined},
          {'title': 'Marks & Results', 'icon': Icons.grade_outlined},
          {'title': 'Certificates', 'icon': Icons.card_membership_outlined},
          {'title': 'Student Progress', 'icon': Icons.show_chart_outlined},
          {'title': 'Notice Board', 'icon': Icons.announcement_outlined},
          {'title': 'Chat Support', 'icon': Icons.chat_bubble_outline},
        ];
      case 'Accountant':
        return [
          {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
          {'title': 'Fee Collection', 'icon': Icons.add_home_work_outlined},
          {'title': 'Student Fees', 'icon': Icons.account_balance_wallet_outlined},
          {'title': 'Staff Salary', 'icon': Icons.payments_outlined},
          {'title': 'Income', 'icon': Icons.trending_up_outlined},
          {'title': 'Expenses', 'icon': Icons.trending_down_outlined},
          {'title': 'Invoices & Receipts', 'icon': Icons.receipt_long_outlined},
          {'title': 'Payment History', 'icon': Icons.history_outlined},
          {'title': 'Reports', 'icon': Icons.analytics_outlined},
        ];
      case 'Student':
        return [
          {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
          {'title': 'Study Material', 'icon': Icons.menu_book_outlined},
          {'title': 'Homework', 'icon': Icons.assignment_outlined},
          {'title': 'Quiz Arena', 'icon': Icons.quiz_outlined},
          {'title': 'Study With Play', 'icon': Icons.sports_esports_outlined},
          {'title': 'AI Learning', 'icon': Icons.psychology_outlined},
          {'title': 'Library', 'icon': Icons.local_library_outlined},
          {'title': 'Audio Story', 'icon': Icons.audiotrack_outlined},
          {'title': 'My Attendance', 'icon': Icons.calendar_today_outlined},
          {'title': 'My Results', 'icon': Icons.grade_outlined},
          {'title': 'My Certificates', 'icon': Icons.card_membership_outlined},
          {'title': 'My Profile', 'icon': Icons.person_outline},
          {'title': 'Rewards & Badges', 'icon': Icons.workspace_premium_outlined},
          {'title': 'Leaderboard', 'icon': Icons.leaderboard_outlined},
        ];
      case 'Parent':
        return [
          {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
          {'title': 'Child Attendance', 'icon': Icons.calendar_today_outlined},
          {'title': 'Homework', 'icon': Icons.assignment_outlined},
          {'title': 'Quiz Scores', 'icon': Icons.quiz_outlined},
          {'title': 'Academic Progress', 'icon': Icons.show_chart_outlined},
          {'title': 'Fee Status', 'icon': Icons.account_balance_wallet_outlined},
          {'title': 'Term Results', 'icon': Icons.grade_outlined},
          {'title': 'Certificates', 'icon': Icons.card_membership_outlined},
          {'title': 'Teacher Chat', 'icon': Icons.chat_bubble_outline},
          {'title': 'Notifications', 'icon': Icons.notifications_active_outlined},
        ];
      default:
        return [
          {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
        ];
    }
  }

  List<Map<String, dynamic>> get _menuItems {
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final user = authVm.userProfile;
    if (user == null) return [];
    return _getMenuItemsForRole(user.role);
  }

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final webVm = Provider.of<WebPanelViewModel>(context);
    final user = authVm.userProfile;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double width = MediaQuery.sizeOf(context).width;

    if (user == null) {
      return const LoginScreen();
    }

    final menuList = _menuItems;
    final int checkedIndex = _selectedMenuIndex >= menuList.length ? 0 : _selectedMenuIndex;
    final bool isMobile = width < 800;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile
          ? Drawer(
              child: SafeArea(
                child: _buildSidebarContent(user, isDark, context, isDrawer: true),
              ),
            )
          : null,
      body: Row(
        children: [
          // Collapsible Sidebar side-by-side only on Desktop/Tablet
          if (!isMobile)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isSidebarCollapsed ? 76 : 280,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: _buildSidebarContent(user, isDark, context, isDrawer: false),
            ),
          
          // Main Content Container
          Expanded(
            child: Column(
              children: [
                // Top Navigation Bar
                _buildTopBar(context, user, isDark),
                
                if (webVm.isMockEnabled)
                  Container(
                    width: double.infinity,
                    color: Colors.amber[800],
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Administrative Warning: You are operating in Local Mock Mode. Notice and Homework edits will not persist to the online cloud database.',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Active Panel View Area
                Expanded(
                  child: Container(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    child: menuList.isNotEmpty 
                        ? _buildActivePanel(context, menuList[checkedIndex], user, isDark)
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(UserProfile user, bool isDark, BuildContext context, {required bool isDrawer}) {
    final menuList = _menuItems;
    final int checkedIndex = _selectedMenuIndex >= menuList.length ? 0 : _selectedMenuIndex;
    final bool collapsedState = isDrawer ? false : _isSidebarCollapsed;

    return Container(
      color: isDark ? AppColors.darkSurface : Colors.white,
      child: Column(
        children: [
          _buildSidebarHeader(user, isDark, isCollapsed: collapsedState),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                final item = menuList[index];
                final isSelected = checkedIndex == index;
                return _buildSidebarItem(
                  item,
                  isSelected,
                  index,
                  isDark,
                  isCollapsed: collapsedState,
                  isDrawer: isDrawer,
                );
              },
            ),
          ),
          const Divider(height: 1),
          _buildSidebarFooter(context, isDark, isCollapsed: collapsedState),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader(UserProfile user, bool isDark, {required bool isCollapsed}) {
    if (isCollapsed) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        child: const Icon(Icons.school, color: AppColors.secondaryOrange, size: 28),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Agarwal Hub',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5),
                ),
                Text(
                  'ADMIN PORTAL',
                  style: TextStyle(color: AppColors.secondaryOrange, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    Map<String, dynamic> item,
    bool isSelected,
    int index,
    bool isDark, {
    required bool isCollapsed,
    required bool isDrawer,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? Colors.white.withOpacity(0.1) : AppColors.primaryBlue.withOpacity(0.08))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          item['icon'],
          color: isSelected ? AppColors.secondaryOrange : (isDark ? Colors.white60 : Colors.black54),
          size: 20,
        ),
        title: isCollapsed
            ? null
            : Text(
                item['title'],
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                  color: isSelected
                      ? (isDark ? Colors.white : AppColors.primaryBlue)
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
        selected: isSelected,
        onTap: () {
          setState(() {
            _selectedMenuIndex = index;
          });
          if (isDrawer) {
            Navigator.pop(context); // Close mobile drawer
          }
        },
      ),
    );
  }

  Widget _buildSidebarFooter(BuildContext context, bool isDark, {required bool isCollapsed}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
        title: isCollapsed
            ? null
            : const Text(
                'Sign Out',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 13),
              ),
        onTap: () async {
          final authVm = Provider.of<AuthViewModel>(context, listen: false);
          await authVm.logout();
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, UserProfile user, bool isDark) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  if (MediaQuery.sizeOf(context).width < 800) {
                    _scaffoldKey.currentState?.openDrawer();
                  } else {
                    setState(() {
                      _isSidebarCollapsed = !_isSidebarCollapsed;
                    });
                  }
                },
              ),
              const SizedBox(width: 12),
              Text(
                _menuItems.isNotEmpty && _selectedMenuIndex < _menuItems.length
                    ? _menuItems[_selectedMenuIndex]['title']
                    : 'Dashboard',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ],
          ),
          
          Row(
            children: [
              // Database Connection Status Badge
              (() {
                final webVm = Provider.of<WebPanelViewModel>(context);
                final bool isLive = !webVm.isMockEnabled;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isLive ? Colors.green.withOpacity(0.12) : Colors.amber.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isLive ? Colors.green.withOpacity(0.3) : Colors.amber.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 3.5,
                        backgroundColor: isLive ? Colors.green : Colors.amber,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isLive ? 'Firebase Live' : 'Offline Mock Mode',
                        style: TextStyle(
                          color: isLive ? Colors.green : Colors.amber.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                );
              })(),
              const SizedBox(width: 14),

              // Theme switcher
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode_outlined),
                onPressed: () => themeProvider.toggleTheme(),
              ),
              const SizedBox(width: 14),
              
              // Profile Quick view
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                child: const Icon(Icons.person, size: 18, color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name.isNotEmpty ? user.name : 'Admin', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(user.role, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 14),
              // Logout & Lock Security Access button
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                tooltip: 'Logout & Lock Security Access',
                onPressed: () async {
                  final authVm = Provider.of<AuthViewModel>(context, listen: false);
                  await authVm.logout();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivePanel(BuildContext context, Map<String, dynamic> item, UserProfile user, bool isDark) {
    final title = item['title'];
    switch (title) {
      case 'Dashboard':
        return SuperAdminDashboardPanel(
          isDark: isDark,
          onDoubtInquiriesTap: () {
            final int doubtsIdx = _menuItems.indexWhere(
              (item) => item['title'] == 'AI Learning' || item['title'] == 'AI Doubts'
            );
            if (doubtsIdx != -1) {
              setState(() {
                _selectedMenuIndex = doubtsIdx;
              });
            }
          },
        );
      case 'Student Management':
      case 'Students':
        return StudentManagementPanel(isDark: isDark);
      case 'Teacher Management':
      case 'Teachers':
        return TeacherManagementPanel(isDark: isDark);
      case 'Class & Subjects':
      case 'Classes & Subjects':
        return ClassSubjectPanel(isDark: isDark);
      case 'Resource Library':
      case 'Study Material':
        return ResourceUploadPanel(isDark: isDark);
      case 'Homework':
        return HomeworkManagementPanel(isDark: isDark);
      case 'Quiz Builder':
      case 'Quiz Arena':
      case 'Quiz Scores':
        return QuizBuilderPanel(isDark: isDark);
      case 'Attendance':
      case 'Child Attendance':
      case 'My Attendance':
        return AttendanceManagementPanel(isDark: isDark);
      case 'Notice Board':
      case 'Notifications':
        return NoticeBoardPanel(isDark: isDark);
      case 'Story Expire':
      case 'Audio Story':
        return StoryUploadPanel(isDark: isDark);
      case 'AI Doubts':
      case 'AI Learning':
        return DoubtPanel(isDark: isDark);
      case 'Push Alerts':
        return NotificationsPanel(isDark: isDark);
      case 'Reports':
      case 'Reports & Analytics':
      case 'Academic Progress':
        return ReportsPanel(isDark: isDark);
      case 'System Settings':
        return WebSettingsPanel(isDark: isDark);
      case 'Parent Management':
      case 'Parents':
        return ParentManagementPanel(isDark: isDark);
      default:
        return GenericRolePanel(
          title: title,
          icon: item['icon'] ?? Icons.extension_outlined,
          isDark: isDark,
        );
    }
  }
}

// ==========================================
// SUB SCREEN 1: SUPER ADMIN DASHBOARD
// ==========================================
class SuperAdminDashboardPanel extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onDoubtInquiriesTap;

  const SuperAdminDashboardPanel({super.key, required this.isDark, this.onDoubtInquiriesTap});

  void _showActiveStudentsDialog(BuildContext context, WebPanelViewModel webVm) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.people, color: AppColors.primaryBlue),
                const SizedBox(width: 10),
                Text('Active Students Roster & Surveillance (${webVm.studentsList.length})'),
              ],
            ),
            content: SizedBox(
              width: 600,
              height: 450,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: webVm.studentsList.map((s) {
                    final duration = s.isOnline ? DateTime.now().difference(s.lastLogin) : null;
                    final durationStr = s.isOnline 
                        ? 'Online now (for ${duration!.inHours}h ${duration.inMinutes % 60}m)' 
                        : 'Offline since ${s.lastActive.day}/${s.lastActive.month} ${s.lastActive.hour}:${s.lastActive.minute.toString().padLeft(2, '0')}';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: s.isOnline ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                        child: Icon(s.isOnline ? Icons.sensors : Icons.person, color: s.isOnline ? Colors.green : Colors.grey),
                      ),
                      title: Text(s.name, style: TextStyle(fontWeight: FontWeight.bold, decoration: s.isBlocked ? TextDecoration.lineThrough : null)),
                      subtitle: Text('Class: ${s.userClass} | $durationStr\nPhone: ${s.phone} | Roll: ${s.rollNumber}'),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: s.isBlocked ? Colors.red.withOpacity(0.12) : (s.isOnline ? Colors.green.withOpacity(0.12) : Colors.grey.withOpacity(0.12)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              s.isBlocked ? 'BLOCKED' : (s.isOnline ? 'ONLINE' : 'OFFLINE'), 
                              style: TextStyle(color: s.isBlocked ? Colors.red : (s.isOnline ? Colors.green : Colors.grey), fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: s.isBlocked ? Colors.green : Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              final updated = s.copyWith(
                                isBlocked: !s.isBlocked,
                                isOnline: !s.isBlocked ? false : s.isOnline,
                              );
                              webVm.updateStudent(updated);
                              setDialogState(() {});
                            },
                            child: Text(s.isBlocked ? 'Unblock' : 'Block', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              final updated = s.copyWith(
                                forceLogout: true,
                                isOnline: false,
                              );
                              webVm.updateStudent(updated);
                              setDialogState(() {});
                            },
                            child: const Text('Logout', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
            ],
          );
        }
      ),
    );
  }

  void _showActiveTeachersDialog(BuildContext context, WebPanelViewModel webVm) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.assignment_ind, color: AppColors.secondaryOrange),
                const SizedBox(width: 10),
                Text('Active Teachers Roster & Status (${webVm.teachersList.length})'),
              ],
            ),
            content: SizedBox(
              width: 600,
              height: 450,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: webVm.teachersList.map((t) {
                    final bool isOnLeave = t.statusNote == 'On Leave';
                    final duration = t.isOnline ? DateTime.now().difference(t.lastLogin) : null;
                    final durationStr = isOnLeave 
                        ? 'On Vacation / Leave' 
                        : (t.isOnline 
                            ? 'Online now (for ${duration!.inHours}h ${duration.inMinutes % 60}m)' 
                            : 'Offline since ${t.lastActive.day}/${t.lastActive.month} ${t.lastActive.hour}:${t.lastActive.minute.toString().padLeft(2, '0')}');

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isOnLeave ? Colors.amber.withOpacity(0.2) : (t.isOnline ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2)),
                        child: Icon(isOnLeave ? Icons.beach_access : Icons.school, color: isOnLeave ? Colors.amber.shade800 : (t.isOnline ? Colors.green : Colors.grey)),
                      ),
                      title: Text(t.name, style: TextStyle(fontWeight: FontWeight.bold, decoration: t.isBlocked ? TextDecoration.lineThrough : null)),
                      subtitle: Text('ID: ${t.admissionNumber} | $durationStr\nPhone: ${t.phone}'),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: t.isBlocked 
                                  ? Colors.red.withOpacity(0.12) 
                                  : (isOnLeave 
                                      ? Colors.amber.withOpacity(0.12) 
                                      : (t.isOnline ? Colors.green.withOpacity(0.12) : Colors.grey.withOpacity(0.12))),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              t.isBlocked 
                                  ? 'BLOCKED' 
                                  : (isOnLeave ? 'LEAVE' : (t.isOnline ? 'ONLINE' : 'OFFLINE')), 
                              style: TextStyle(
                                  color: t.isBlocked 
                                      ? Colors.red 
                                      : (isOnLeave ? Colors.amber.shade800 : (t.isOnline ? Colors.green : Colors.grey)), 
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: t.isBlocked ? Colors.green : Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                               final updated = t.copyWith(
                                 isBlocked: !t.isBlocked,
                                 isOnline: !t.isBlocked ? false : t.isOnline,
                               );
                               webVm.updateTeacher(updated);
                              setDialogState(() {});
                            },
                            child: Text(t.isBlocked ? 'Unblock' : 'Block', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
            ],
          );
        }
      ),
    );
  }

  void _showActiveClassesDialog(BuildContext context, WebPanelViewModel webVm) {
    final classes = ['Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.class_, color: AppColors.accentGreen),
            SizedBox(width: 10),
            Text('Active Academic Classes Roster (Class 1 to 12)'),
          ],
        ),
        content: SizedBox(
          width: 500,
          height: 400,
          child: ListView.separated(
            itemCount: classes.length,
            separatorBuilder: (ctx, idx) => const Divider(),
            itemBuilder: (ctx, idx) {
              final c = classes[idx];
              final count = webVm.studentsList.where((s) => s.userClass == c).length;
              return ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.school, color: Colors.white)),
                title: Text(c, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Board: CBSE / BSEB | Subjects: Math, Science, English, Computer...'),
                trailing: Text('$count Registered Student(s)', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final webVm = Provider.of<WebPanelViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row of stats cards with click-to-view active rosters
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.0,
            children: [
              _buildStatCard(
                'Total Students', 
                '${webVm.totalStudents}', 
                Icons.people, 
                AppColors.primaryBlue,
                onTap: () => _showActiveStudentsDialog(context, webVm),
              ),
              _buildStatCard(
                'Total Teachers', 
                '${webVm.totalTeachers}', 
                Icons.assignment_ind, 
                AppColors.secondaryOrange,
                onTap: () => _showActiveTeachersDialog(context, webVm),
              ),
              _buildStatCard(
                'Active Classes', 
                '${webVm.totalClasses}', 
                Icons.class_, 
                AppColors.accentGreen,
                onTap: () => _showActiveClassesDialog(context, webVm),
              ),
              _buildStatCard(
                'Doubt Inquiries', 
                '${webVm.doubtQueries.where((d) => d['status'] == 'Pending').length}', 
                Icons.chat_bubble, 
                Colors.purple,
                onTap: onDoubtInquiriesTap,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Charts
              Expanded(
                flex: 2,
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Today\'s System Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      // Mocking a graphic chart with container segments
                      Container(
                        height: 200,
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildChartBar('Mon', 45, AppColors.primaryBlue),
                            _buildChartBar('Tue', 65, AppColors.primaryBlue),
                            _buildChartBar('Wed', 80, AppColors.primaryBlue),
                            _buildChartBar('Thu', 70, AppColors.primaryBlue),
                            _buildChartBar('Fri', 90, AppColors.secondaryOrange),
                            _buildChartBar('Sat', 30, AppColors.primaryBlue),
                            _buildChartBar('Sun', 15, AppColors.primaryBlue),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              
              // Right: Storage Limit Progress
              Expanded(
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cloud Storage Space', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 24),
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 12.0,
                        percent: webVm.storageUsageGb / 5.0,
                        center: Text(
                          "${((webVm.storageUsageGb / 5.0) * 100).toInt()}%",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        progressColor: AppColors.secondaryOrange,
                        backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Using ${webVm.storageUsageGb} GB of 5.0 GB Cloud Space',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const Text('Includes homework attachments, PDFs, and photos.', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? null : Colors.white,
          gradient: isDark
              ? LinearGradient(
                  colors: [
                    color.withOpacity(0.18),
                    color.withOpacity(0.03),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? color.withOpacity(0.25) : Colors.grey.shade100,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.12),
              offset: const Offset(0, 4),
              blurRadius: 10,
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: isDark ? Colors.white : color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

  Widget _buildChartBar(String label, int heightPercent, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: (heightPercent * 1.5).toDouble(),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ==========================================
// SUB SCREEN 2: STUDENT MANAGEMENT PANEL
// ==========================================
class StudentManagementPanel extends StatefulWidget {
  final bool isDark;

  const StudentManagementPanel({super.key, required this.isDark});

  @override
  State<StudentManagementPanel> createState() => _StudentManagementPanelState();
}

class _StudentManagementPanelState extends State<StudentManagementPanel> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _classController = TextEditingController();
  final _rollController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _classController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  void _onAddStudent() {
    final name = _nameController.text.trim();
    final rawPhone = _phoneController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final userClass = _classController.text.trim();
    final rollNumber = _rollController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Error: Please enter Student Full Name'), backgroundColor: Colors.red),
      );
      return;
    }

    // 1. REAL Mobile Number Validation (Must be valid 10-digit Indian number starting with 6,7,8,9)
    final cleanPhone = rawPhone.replaceAll('+91', '').replaceAll(' ', '').trim();
    final phoneRegExp = RegExp(r'^[6-9]\d{9}$');
    final isFakePhone = ['1234567890', '0000000000', '9999999999', '1111111111', '8888888888'].contains(cleanPhone);

    if (!phoneRegExp.hasMatch(cleanPhone) || isFakePhone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Error: Please enter a REAL valid 10-digit mobile number starting with 6, 7, 8, or 9. Fake numbers are rejected!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2. REAL Email Address Validation (Must be valid RFC email containing @ and domain like .com)
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Error: Please enter a REAL valid Email address containing @ and domain (.com)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final formattedPhone = '+91$cleanPhone';
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);

    final student = UserProfile(
      uid: 'std_${DateTime.now().millisecondsSinceEpoch}',
      role: AppStrings.roleStudent,
      name: name,
      phone: formattedPhone,
      email: email,
      address: 'Patna',
      userClass: userClass.isNotEmpty ? userClass : 'Class 5',
      rollNumber: rollNumber.isNotEmpty ? rollNumber : '01',
      gender: 'Male',
      dob: '2015-01-01',
      admissionNumber: 'ADM-${DateTime.now().millisecond}',
      school: 'Agarwal Knowledge Hub',
      parentName: '',
      parentMobile: '',
      emergencyContact: '',
      profilePhotoUrl: '',
      createdDate: DateTime.now(),
      lastLogin: DateTime.now(),
      isOnline: false,
      lastActive: DateTime.now(),
    );

    webVm.addStudent(student);
    
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _classController.clear();
    _rollController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Student "$name" successfully registered with verified Mobile & Email!'),
        backgroundColor: Colors.green,
      ),
    );
  }
    
  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  void _showStudentActivityDialog(BuildContext context, UserProfile student) {
    final bool isGmailUser = student.email.isNotEmpty;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(isGmailUser ? Icons.email : Icons.phone_android, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Text('${student.name} - ${isGmailUser ? "Gmail/Email" : "Mobile"} Activity Log'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Admission Number: ${student.admissionNumber.isNotEmpty ? student.admissionNumber : 'ADM-5001'}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('• Current Class: ${student.userClass} (Roll No: ${student.rollNumber})'),
            const SizedBox(height: 6),
            Text('• Auth Method: ${isGmailUser ? "Gmail / Email Login (${student.email})" : "Mobile OTP Login (${student.phone})"}', 
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            const SizedBox(height: 6),
            Text('• Parent Name: ${student.parentName.isNotEmpty ? student.parentName : "N/A"} (${student.parentMobile.isNotEmpty ? student.parentMobile : "N/A"})'),
            const SizedBox(height: 6),
            Text('• Account Status: ${student.isBlocked ? 'BLOCKED / SUSPENDED 🔴' : 'ACTIVE 🟢'}', 
                style: TextStyle(color: student.isBlocked ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('• Live Presence: ${student.isOnline ? 'Online now (Active in App 🟢)' : 'Offline ⚪'}'),
            const SizedBox(height: 6),
            Text('• Last Active Timestamp: ${student.lastActive.day}/${student.lastActive.month}/${student.lastActive.year} at ${student.lastActive.hour}:${student.lastActive.minute.toString().padLeft(2, '0')}'),
            const SizedBox(height: 6),
            Text('• Session History Log: ${isGmailUser ? "Gmail OAuth Session Verified (Live Tracker Active)" : "SMS OTP Session Verified (Live Tracker Active)"}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close Log'),
          ),
        ],
      ),
    );
  }

  void _showEditStudentDialog(BuildContext context, UserProfile student) {
    final nameCtrl = TextEditingController(text: student.name);
    final phoneCtrl = TextEditingController(text: student.phone);
    final emailCtrl = TextEditingController(text: student.email);
    final classCtrl = TextEditingController(text: student.userClass);
    final rollCtrl = TextEditingController(text: student.rollNumber);
    final addressCtrl = TextEditingController(text: student.address);
    final parentNameCtrl = TextEditingController(text: student.parentName);
    final parentMobileCtrl = TextEditingController(text: student.parentMobile);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.edit_outlined, color: AppColors.primaryBlue),
            const SizedBox(width: 10),
            const Text('Edit Student Details'),
          ],
        ),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: nameCtrl,
                  labelText: 'Student Name',
                  hintText: 'e.g. Aman Agarwal',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: phoneCtrl,
                  labelText: 'Real Phone Number',
                  hintText: 'e.g. +919876543210',
                  prefixIcon: Icons.phone_android_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: emailCtrl,
                  labelText: 'Real Email Address (Gmail)',
                  hintText: 'e.g. student@gmail.com',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: classCtrl,
                  labelText: 'Class Assignment',
                  hintText: 'e.g. Class 5',
                  prefixIcon: Icons.school_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: rollCtrl,
                  labelText: 'Roll Number',
                  hintText: 'e.g. 12',
                  prefixIcon: Icons.format_list_numbered_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: addressCtrl,
                  labelText: 'Address',
                  hintText: 'e.g. Mithapur, Patna',
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: parentNameCtrl,
                  labelText: 'Parent Name',
                  hintText: 'e.g. Suresh Agarwal',
                  prefixIcon: Icons.family_restroom,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: parentMobileCtrl,
                  labelText: 'Parent Mobile',
                  hintText: 'e.g. +919876543220',
                  prefixIcon: Icons.phone_callback,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final updated = student.copyWith(
                name: nameCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                userClass: classCtrl.text.trim(),
                rollNumber: rollCtrl.text.trim(),
                address: addressCtrl.text.trim(),
                parentName: parentNameCtrl.text.trim(),
                parentMobile: parentMobileCtrl.text.trim(),
              );
              Provider.of<WebPanelViewModel>(context, listen: false).updateStudent(updated);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Details of ${student.name} updated successfully! 🔄')),
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final webVm = Provider.of<WebPanelViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context);
    final isSuperAdmin = authVm.userProfile?.role == AppStrings.roleSuperAdmin;

    final int totalCount = webVm.studentsList.length;
    final int onlineCount = webVm.studentsList.where((s) => s.isOnline).length;
    final int offlineCount = webVm.studentsList.where((s) => !s.isOnline).length;
    final int blockedCount = webVm.studentsList.where((s) => s.isBlocked).length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Registries list
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Live Active Surveillance Counter Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: widget.isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniStat('Total Students', '$totalCount', Icons.people, AppColors.primaryBlue),
                      _buildMiniStat('Live Active 🟢', '$onlineCount', Icons.sensors, Colors.green),
                      _buildMiniStat('Offline ⚪', '$offlineCount', Icons.sensors_off, Colors.grey),
                      _buildMiniStat('Blocked ⛔', '$blockedCount', Icons.block, Colors.red),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Student Roster & Activity Surveillance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    if (isSuperAdmin)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: const Text('Super Admin Surveillance Controls Active 🛡️', 
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: webVm.studentsList.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final student = webVm.studentsList[index];
                      return ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: student.isBlocked ? Colors.red.withOpacity(0.2) : null,
                              child: Icon(student.isBlocked ? Icons.block : Icons.person, color: student.isBlocked ? Colors.red : null),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: student.isBlocked ? Colors.red : (student.isOnline ? Colors.green : Colors.grey),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Row(
                          children: [
                            Text(
                              student.name, 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: student.isBlocked ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (student.isBlocked)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'BLOCKED',
                                  style: TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              )
                            else if (student.isOnline)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Online Now 🟢',
                                  style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Offline ⚪',
                                  style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text('Class: ${student.userClass} | Phone: ${student.phone} | Roll: ${student.rollNumber}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Info surveillance dialog icon
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined, color: AppColors.primaryBlue),
                              tooltip: 'View Online History & Logs',
                              onPressed: () => _showStudentActivityDialog(context, student),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                              tooltip: 'Edit Personal Details',
                              onPressed: () => _showEditStudentDialog(context, student),
                            ),

                             // Super Admin Block/Unblock Control Button
                             if (isSuperAdmin) ...[
                               ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: student.isBlocked ? Colors.green : Colors.red,
                                   foregroundColor: Colors.white,
                                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                   minimumSize: Size.zero,
                                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                 ),
                                 onPressed: () {
                                   final updated = student.copyWith(
                                     isBlocked: !student.isBlocked,
                                     isOnline: !student.isBlocked ? false : student.isOnline,
                                   );
                                   webVm.updateStudent(updated);
                                   ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                       content: Text(student.isBlocked ? '${student.name} Unblocked!' : '${student.name} Blocked!'),
                                     ),
                                   );
                                 },
                                 child: Text(student.isBlocked ? 'Unblock' : 'Block', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                               ),
                               const SizedBox(width: 8),
                               ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: Colors.orange.shade700,
                                   foregroundColor: Colors.white,
                                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                   minimumSize: Size.zero,
                                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                 ),
                                 onPressed: () {
                                   final updated = student.copyWith(
                                     forceLogout: true,
                                     isOnline: false,
                                   );
                                   webVm.updateStudent(updated);
                                   ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                       content: Text('Force Logout command sent to ${student.name}\'s active sessions!'),
                                       backgroundColor: Colors.orange.shade700,
                                     ),
                                   );
                                 },
                                 child: const Text('Force Logout', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                               ),
                             ],
                            
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error),
                              onPressed: () => webVm.deleteStudent(student.uid),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        
        // Right: Form to add student
        Container(
          width: 340,
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.darkSurface : Colors.white,
            border: Border(
              left: BorderSide(color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New Student', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'e.g. Aman Agarwal',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                labelText: 'Real Phone Number (+91)',
                hintText: 'e.g. 9876543210',
                prefixIcon: Icons.phone_android_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: 'Real Email Address (Gmail)',
                hintText: 'e.g. student@gmail.com',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _classController,
                labelText: 'Class Assignment',
                hintText: 'e.g. Class 5',
                prefixIcon: Icons.school_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _rollController,
                labelText: 'Roll Number',
                hintText: 'e.g. 12',
                prefixIcon: Icons.format_list_numbered_outlined,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Register Student',
                onPressed: _onAddStudent,
              )
            ],
          ),
        )
      ],
    );
  }
}

// ==========================================
// SUB SCREEN 3: TEACHER MANAGEMENT PANEL
// ==========================================
class TeacherManagementPanel extends StatefulWidget {
  final bool isDark;

  const TeacherManagementPanel({super.key, required this.isDark});

  @override
  State<TeacherManagementPanel> createState() => _TeacherManagementPanelState();
}

class _TeacherManagementPanelState extends State<TeacherManagementPanel> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();

  void _onAddTeacher() {
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);
    final teacher = UserProfile(
      uid: 'tch_${DateTime.now().millisecondsSinceEpoch}',
      role: AppStrings.roleTeacher,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: '',
      address: '',
      userClass: '',
      rollNumber: '',
      gender: '',
      dob: '',
      admissionNumber: 'TCH-${DateTime.now().millisecond}',
      school: 'Agarwal Knowledge Hub',
      parentName: '',
      parentMobile: '',
      emergencyContact: '',
      profilePhotoUrl: '',
      createdDate: DateTime.now(),
      lastLogin: DateTime.now(),
    );

    webVm.addTeacher(teacher);
    
    _nameController.clear();
    _phoneController.clear();
    _subjectController.clear();
  }

  Widget _buildTeacherStat(String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  void _showTeacherActivityDialog(BuildContext context, UserProfile teacher) {
    final bool isOnline = teacher.isOnline;
    final bool isOnLeave = teacher.statusNote == 'On Leave';
    
    String presenceText = '';
    String durationText = '';
    
    if (isOnLeave) {
      presenceText = 'ON LEAVE 🟡 (Vacation / Leave Active)';
      durationText = 'Teacher is currently off duty.';
    } else if (isOnline) {
      presenceText = 'LIVE ONLINE 🟢 (Active in Class / App)';
      final duration = DateTime.now().difference(teacher.lastLogin);
      if (duration.inMinutes < 1) {
        durationText = 'Just connected a few seconds ago.';
      } else {
        durationText = 'Online for ${duration.inHours} hrs, ${duration.inMinutes % 60} mins (since ${teacher.lastLogin.hour}:${teacher.lastLogin.minute.toString().padLeft(2, '0')}).';
      }
    } else {
      presenceText = 'OFFLINE ⚪ (Inactive)';
      final diff = DateTime.now().difference(teacher.lastActive);
      if (diff.inMinutes < 60) {
        durationText = 'Offline since ${diff.inMinutes} minutes ago.';
      } else if (diff.inHours < 24) {
        durationText = 'Offline since ${diff.inHours} hours ago.';
      } else {
        durationText = 'Offline since ${teacher.lastActive.day}/${teacher.lastActive.month}/${teacher.lastActive.year}.';
      }
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.school, color: AppColors.secondaryOrange),
            const SizedBox(width: 8),
            Text('${teacher.name} - Teacher Activity Log'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Teacher ID: ${teacher.admissionNumber.isNotEmpty ? teacher.admissionNumber : 'TCH-001'}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('• Assigned Subjects / Role: ${teacher.role}'),
            const SizedBox(height: 6),
            Text('• Contact Phone: ${teacher.phone}'),
            const SizedBox(height: 6),
            Text('• Account Status: ${teacher.isBlocked ? 'BLOCKED / SUSPENDED 🔴' : 'ACTIVE 🟢'}', 
                style: TextStyle(color: teacher.isBlocked ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('• Live Presence: $presenceText', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('• Session History: $durationText', style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
            const SizedBox(height: 6),
            Text('• Last Active Timestamp: ${teacher.lastActive.day}/${teacher.lastActive.month}/${teacher.lastActive.year} at ${teacher.lastActive.hour}:${teacher.lastActive.minute.toString().padLeft(2, '0')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close Log'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final webVm = Provider.of<WebPanelViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context);
    final isSuperAdmin = authVm.userProfile?.role == AppStrings.roleSuperAdmin;

    final int totalCount = webVm.teachersList.length;
    final int onlineCount = webVm.teachersList.where((t) => t.isOnline).length;
    final int leaveCount = webVm.teachersList.where((t) => t.statusNote == 'On Leave').length;
    final int offlineCount = webVm.teachersList.where((t) => !t.isOnline && t.statusNote != 'On Leave').length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Teachers list
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Live Active Surveillance Counter Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: widget.isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.secondaryOrange.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTeacherStat('Total Teachers', '$totalCount', Icons.assignment_ind, AppColors.secondaryOrange),
                      _buildTeacherStat('Teaching Live 🟢', '$onlineCount', Icons.sensors, Colors.green),
                      _buildTeacherStat('Offline ⚪', '$offlineCount', Icons.sensors_off, Colors.grey),
                      _buildTeacherStat('On Leave 🟡', '$leaveCount', Icons.beach_access, Colors.amber),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Teachers Roster & Active Class Surveillance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    if (isSuperAdmin)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryOrange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.secondaryOrange.withOpacity(0.3)),
                        ),
                        child: const Text('Super Admin Teacher Controls Active 🛡️', 
                            style: TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: webVm.teachersList.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final teacher = webVm.teachersList[index];
                      final bool isOnLeave = teacher.statusNote == 'On Leave';

                      return ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: isOnLeave ? Colors.amber.withOpacity(0.2) : null,
                              child: Icon(isOnLeave ? Icons.beach_access : Icons.school, color: isOnLeave ? Colors.amber.shade800 : null),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: isOnLeave ? Colors.amber : (teacher.isOnline ? Colors.green : Colors.grey),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Row(
                          children: [
                            Text(teacher.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            if (isOnLeave)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'ON LEAVE 🟡',
                                  style: TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              )
                            else if (teacher.isOnline)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Live Teaching 🟢',
                                  style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Offline ⚪',
                                  style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text('Role: ${teacher.role} | Phone: ${teacher.phone} | ID: ${teacher.admissionNumber}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined, color: AppColors.primaryBlue),
                              tooltip: 'View Online History & Logs',
                              onPressed: () => _showTeacherActivityDialog(context, teacher),
                            ),
                            if (isSuperAdmin) ...[
                              const SizedBox(width: 4),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isOnLeave ? Colors.green : Colors.amber.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  final updated = teacher.copyWith(
                                    statusNote: isOnLeave ? 'Active' : 'On Leave',
                                    isOnline: isOnLeave ? teacher.isOnline : false,
                                  );
                                  webVm.updateTeacher(updated);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(isOnLeave ? '${teacher.name} marked Active!' : '${teacher.name} granted Leave!'),
                                    ),
                                  );
                                },
                                child: Text(isOnLeave ? 'Mark Active' : 'Grant Leave', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: teacher.isBlocked ? Colors.green : Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  final updated = teacher.copyWith(
                                    isBlocked: !teacher.isBlocked,
                                    isOnline: !teacher.isBlocked ? false : teacher.isOnline,
                                  );
                                  webVm.updateTeacher(updated);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(teacher.isBlocked ? '${teacher.name} Unblocked!' : '${teacher.name} Blocked!'),
                                    ),
                                  );
                                },
                                child: Text(teacher.isBlocked ? 'Unblock' : 'Block', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                onPressed: () => webVm.deleteTeacher(teacher.uid),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        
        // Right: Form to add teacher
        if (isSuperAdmin)
          Container(
          width: 340,
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.darkSurface : Colors.white,
            border: Border(
              left: BorderSide(color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New Teacher', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'e.g. Ms. Anjali Verma',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                hintText: 'e.g. +919876543222',
                prefixIcon: Icons.phone_android_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _subjectController,
                labelText: 'Assign Subjects',
                hintText: 'e.g. English, Computer',
                prefixIcon: Icons.book_outlined,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Register Teacher',
                onPressed: _onAddTeacher,
              )
            ],
          ),
        )
      ],
    );
  }
}

// ==========================================
// SUB SCREEN 4: CLASS & SUBJECT PANEL
// ==========================================
class ClassSubjectPanel extends StatelessWidget {
  final bool isDark;

  const ClassSubjectPanel({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Academic Structure', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Active Classes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 12),
                      _buildMiniListItem('CBSE Nursery-5'),
                      const Divider(),
                      _buildMiniListItem('BSEB Class 1-7'),
                      const Divider(),
                      _buildMiniListItem('Computer Science'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Course Subjects', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 12),
                      _buildMiniListItem('Mathematics'),
                      const Divider(),
                      _buildMiniListItem('English Grammar'),
                      const Divider(),
                      _buildMiniListItem('Computer Theory'),
                      const Divider(),
                      _buildMiniListItem('Computer Practical'),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMiniListItem(String title) {
    return ListTile(
      leading: const Icon(Icons.check_circle_outline, color: AppColors.accentGreen),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      dense: true,
    );
  }
}

// ==========================================
// SUB SCREEN 5: RESOURCE UPLOAD PANEL
// ==========================================
class ResourceUploadPanel extends StatefulWidget {
  final bool isDark;

  const ResourceUploadPanel({super.key, required this.isDark});

  @override
  State<ResourceUploadPanel> createState() => _ResourceUploadPanelState();
}

class _ResourceUploadPanelState extends State<ResourceUploadPanel> {
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _classController = TextEditingController();
  
  String _mediaType = 'pdf';

  void _onUpload() {
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);
    final note = Note(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: 'Uploaded from Administration Web Panel.',
      userClass: _classController.text.trim(),
      subject: _subjectController.text.trim(),
      fileUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      mediaType: _mediaType,
      uploadedBy: 'web_admin',
      uploaderName: 'Super Admin',
      createdDate: DateTime.now(),
    );

    webVm.uploadNote(note);

    _titleController.clear();
    _subjectController.clear();
    _classController.clear();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lecture resource uploaded successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: MaxWidthContainer(
        child: GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Upload Educational Content (Notes, PDFs, Videos)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Content Type: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _mediaType,
                    items: const [
                      DropdownMenuItem(value: 'pdf', child: Text('PDF Document')),
                      DropdownMenuItem(value: 'video', child: Text('Lecture Video')),
                      DropdownMenuItem(value: 'note', child: Text('Written Note')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _mediaType = val);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _titleController,
                labelText: 'Content Title',
                hintText: 'e.g. Fractions Chapter Notes',
                prefixIcon: Icons.title,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _subjectController,
                labelText: 'Subject',
                hintText: 'e.g. Mathematics',
                prefixIcon: Icons.book,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _classController,
                labelText: 'Class',
                hintText: 'e.g. Class 5',
                prefixIcon: Icons.school,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Publish Resource',
                onPressed: _onUpload,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SUB SCREEN 6: HOMEWORK MANAGEMENT PANEL
// ==========================================
class HomeworkManagementPanel extends StatefulWidget {
  final bool isDark;

  const HomeworkManagementPanel({super.key, required this.isDark});

  @override
  State<HomeworkManagementPanel> createState() => _HomeworkManagementPanelState();
}

class _HomeworkManagementPanelState extends State<HomeworkManagementPanel> {
  String _selectedClass = 'Class 5';

  final List<String> _classes = [
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10',
    'Class 11',
    'Class 12',
    'Computer Theory',
    'Computer Practical',
  ];

  final List<String> _subjects = [
    'Mathematics',
    'Science',
    'English',
    'Hindi',
    'History',
    'Geography',
    'Political Science',
    'Social Science',
    'Computer Science',
    'Computer',
    'General',
  ];

  bool _isPublishing = false;

  final List<Map<String, dynamic>> _homeworkRows = [
    {
      'subject': 'Mathematics',
      'title': 'Maths Exercise 1',
      'description': 'Solve Questions 1 to 5 from Page 20.',
      'imageBytes': null,
      'imageName': null,
      'mimeType': null,
    }
  ];

  void _addSubjectRow() {
    setState(() {
      _homeworkRows.add({
        'subject': 'Science',
        'title': '',
        'description': '',
        'imageBytes': null,
        'imageName': null,
        'mimeType': null,
      });
    });
  }

  void _removeSubjectRow(int index) {
    if (_homeworkRows.length > 1) {
      setState(() {
        _homeworkRows.removeAt(index);
      });
    }
  }

  void _pickImage(Map<String, dynamic> row) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          row['imageBytes'] = bytes;
          row['imageName'] = image.name;
          row['mimeType'] = image.mimeType ?? 'image/jpeg';
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _onPublish() async {
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final currentUserName = authVm.userProfile?.name ?? 'Super Admin';
    final currentUserId = authVm.userProfile?.uid ?? 'web_admin';

    setState(() => _isPublishing = true);

    int count = 0;
    try {
      for (var row in _homeworkRows) {
        final String title = row['title']?.toString().trim() ?? '';
        final String desc = row['description']?.toString().trim() ?? '';
        final String subj = row['subject']?.toString() ?? 'General';

        if (title.isEmpty || desc.isEmpty) continue;

        String fileUrl = '';
        String fileName = '';

        if (row['imageBytes'] != null) {
          final String uploadName = 'hw_${DateTime.now().millisecondsSinceEpoch}_${row['imageName']}';
          fileUrl = await webVm.uploadHomeworkFile(
            row['imageBytes'] as List<int>,
            uploadName,
            row['mimeType']?.toString() ?? 'image/jpeg',
          );
          fileName = row['imageName']?.toString() ?? 'homework_image.jpg';
        }

        final hw = Homework(
          id: 'hw_${DateTime.now().millisecondsSinceEpoch}_$count',
          title: title,
          description: desc,
          userClass: _selectedClass,
          fileUrl: fileUrl,
          fileName: fileName,
          deadline: DateTime.now().add(const Duration(days: 2)),
          teacherId: currentUserId,
          teacherName: currentUserName,
          createdDate: DateTime.now(),
          subject: subj,
          seenBy: const [],
        );

        await webVm.uploadHomework(hw);
        count++;
      }
    } catch (e) {
      debugPrint("Error publishing homework tasks: $e");
    }

    setState(() => _isPublishing = false);

    if (count > 0) {
      setState(() {
        _homeworkRows.clear();
        _homeworkRows.add({
          'subject': 'Mathematics',
          'title': '',
          'description': '',
          'imageBytes': null,
          'imageName': null,
          'mimeType': null,
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully published $count homework tasks for $_selectedClass!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out title and instructions for at least one subject.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final webVm = Provider.of<WebPanelViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context);
    final userRole = authVm.userProfile?.role ?? 'Super Admin';

    // Verify roles: Super Admin, Principal (Admin), and Teacher have access
    final bool hasPermission = userRole == 'Super Admin' || userRole == 'Admin' || userRole == 'Teacher';

    if (!hasPermission) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Access Denied: Only Super Admin, Principal, and Teachers can publish or view homework logs.',
            style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: MaxWidthContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Create New Homework (Multi-Subject Dashboard)', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  
                  // Class Selection Dropdown
                  Row(
                    children: [
                      const Icon(Icons.school, color: AppColors.primaryBlue),
                      const SizedBox(width: 12),
                      const Text('Select Target Class: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedClass,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedClass = val;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  const Text('Homework Assignments by Subject', 
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  const SizedBox(height: 16),

                  // Dynamic list of subject homework builders
                  Column(
                    children: List.generate(_homeworkRows.length, (index) {
                      final row = _homeworkRows[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Subject Assignment #${index + 1}', 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                if (_homeworkRows.length > 1)
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () => _removeSubjectRow(index),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            
                            // Subject selector
                            DropdownButtonFormField<String>(
                              value: row['subject'],
                              decoration: InputDecoration(
                                labelText: 'Subject',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    row['subject'] = val;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Task Title
                            TextFormField(
                              initialValue: row['title'],
                              decoration: InputDecoration(
                                labelText: 'Task Title',
                                hintText: 'e.g. Worksheet or Chapter revision',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onChanged: (val) {
                                row['title'] = val;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Description / What to do
                            TextFormField(
                              initialValue: row['description'],
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Homework Instructions / What to do',
                                hintText: 'Provide detailed list of questions, pages, or guidelines...',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onChanged: (val) {
                                row['description'] = val;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Add Picture / Image Upload Box
                            InkWell(
                              onTap: _isPublishing ? null : () => _pickImage(row),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryOrange.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.secondaryOrange.withOpacity(0.4), width: 1.5),
                                ),
                                child: row['imageBytes'] != null
                                    ? Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.memory(
                                              row['imageBytes'] as Uint8List,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Selected Homework Image Attachment:',
                                                  style: TextStyle(fontSize: 11, color: widget.isDark ? Colors.grey[400] : Colors.grey[700]),
                                                ),
                                                Text(
                                                  row['imageName']?.toString() ?? 'image.jpg',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                row['imageBytes'] = null;
                                                row['imageName'] = null;
                                                row['mimeType'] = null;
                                              });
                                            },
                                          ),
                                        ],
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo_outlined, color: AppColors.secondaryOrange, size: 24),
                                          SizedBox(width: 10),
                                          Text(
                                            '📷 Attach Homework Picture / Diagram (Click to select from phone gallery)',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.secondaryOrange,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Row Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Subject'),
                        onPressed: _isPublishing ? null : _addSubjectRow,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      _isPublishing
                          ? const Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 12),
                                Text('Publishing and Uploading...', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            )
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.cloud_upload),
                              label: const Text('Publish Homework to Class'),
                              onPressed: _onPublish,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Homework logs and student views tracker list
            GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Homework Status & Student Seen Tracker', 
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Chip(
                        label: Text('${webVm.homeworksList.length} Tasks active'),
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                        labelStyle: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  webVm.homeworksList.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            child: Text('No homework has been published yet.', style: TextStyle(color: Colors.grey)),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: webVm.homeworksList.length,
                          separatorBuilder: (context, index) => const Divider(height: 24),
                          itemBuilder: (context, index) {
                            final hw = webVm.homeworksList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryBlue.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                hw.userClass,
                                                style: const TextStyle(
                                                  color: AppColors.primaryBlue,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors.secondaryOrange.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                hw.subject,
                                                style: const TextStyle(
                                                  color: AppColors.secondaryOrange,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(hw.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Deadline: ${hw.deadline.day}/${hw.deadline.month}/${hw.deadline.year}',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.remove_red_eye_outlined, color: Colors.green, size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${hw.seenBy.length} Student(s) seen',
                                              style: const TextStyle(
                                                fontSize: 12, 
                                                color: Colors.green, 
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  hw.description,
                                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (hw.seenBy.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.06),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Seen by: ${hw.seenBy.join(", ")}',
                                      style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SUB SCREEN 7: QUIZ BUILDER PANEL
// ==========================================
class QuizBuilderPanel extends StatefulWidget {
  final bool isDark;

  const QuizBuilderPanel({super.key, required this.isDark});

  @override
  State<QuizBuilderPanel> createState() => _QuizBuilderPanelState();
}

class _QuizBuilderPanelState extends State<QuizBuilderPanel> {
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _classController = TextEditingController();

  void _onSaveQuiz() {
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);
    final quiz = Quiz(
      id: 'qz_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      subject: _subjectController.text.trim(),
      userClass: _classController.text.trim(),
      questions: [
        QuizQuestion(
          questionText: "Sample Question 1",
          options: ["A", "B", "C", "D"],
          correctOptionIndex: 0,
        ),
      ],
      deadline: DateTime.now().add(const Duration(days: 3)),
      timeLimitMinutes: 10,
      teacherId: 'web_admin',
      createdDate: DateTime.now(),
    );

    webVm.uploadQuiz(quiz);

    _titleController.clear();
    _subjectController.clear();
    _classController.clear();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz template initialized.')));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: MaxWidthContainer(
        child: GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Quiz Template Builder', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _titleController,
                labelText: 'Quiz Title',
                hintText: 'e.g. Chapter 2 Quiz',
                prefixIcon: Icons.quiz,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _subjectController,
                labelText: 'Subject',
                hintText: 'e.g. Computer Science',
                prefixIcon: Icons.book,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _classController,
                labelText: 'Class',
                hintText: 'e.g. Computer Theory',
                prefixIcon: Icons.school,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Create Quiz Template',
                onPressed: _onSaveQuiz,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SUB SCREEN 8: ATTENDANCE PANEL
// ==========================================
class AttendanceManagementPanel extends StatelessWidget {
  final bool isDark;

  const AttendanceManagementPanel({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final webVm = Provider.of<WebPanelViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daily Attendance Grid', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Export Report'),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Student Name', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Class', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Present', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Absent', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: webVm.studentsList.map((student) {
                return DataRow(
                  cells: [
                    DataCell(Text(student.name)),
                    DataCell(Text(student.userClass)),
                    const DataCell(Icon(Icons.check_box_outlined, color: AppColors.accentGreen)),
                    const DataCell(Icon(Icons.check_box_outline_blank, color: Colors.grey)),
                  ],
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// SUB SCREEN 9: NOTICE PANEL
// ==========================================
class NoticeBoardPanel extends StatefulWidget {
  final bool isDark;

  const NoticeBoardPanel({super.key, required this.isDark});

  @override
  State<NoticeBoardPanel> createState() => _NoticeBoardPanelState();
}

class _NoticeBoardPanelState extends State<NoticeBoardPanel> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedType = 'General';
  
  final List<String> _types = ['General', 'Urgent', 'Announcement'];

  void _onPublish() {
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final senderName = authVm.userProfile?.name ?? 'Super Admin';

    final notice = Notice(
      id: 'ntc_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      type: _selectedType,
      createdDate: DateTime.now(),
      sender: senderName,
    );

    webVm.publishNotice(notice);

    _titleController.clear();
    _contentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notice bulletin published successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    final webVm = Provider.of<WebPanelViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context);
    final userRole = authVm.userProfile?.role ?? 'Super Admin';

    // Verify roles: Super Admin, Principal (Admin), and Teacher have access
    final bool hasPermission = userRole == 'Super Admin' || userRole == 'Admin' || userRole == 'Teacher';

    if (!hasPermission) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Access Denied: Only Super Admin, Principal, and Teachers can publish or view notice logs.',
            style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: MaxWidthContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Publish Notice Board Announcement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  
                  // Notice Title
                  CustomTextField(
                    controller: _titleController,
                    labelText: 'Notice Title',
                    hintText: 'e.g. Holiday Announcement',
                    prefixIcon: Icons.announcement,
                  ),
                  const SizedBox(height: 16),
                  
                  // Notice Type Selector
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Notice Type',
                      prefixIcon: const Icon(Icons.label, color: AppColors.primaryBlue),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedType = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Content Details
                  CustomTextField(
                    controller: _contentController,
                    labelText: 'Notice Content Details',
                    hintText: 'Schools will remain closed...',
                    prefixIcon: Icons.description,
                  ),
                  const SizedBox(height: 24),
                  
                  CustomButton(
                    text: 'Publish Announcement',
                    onPressed: _onPublish,
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Notice logs and status tracker list
            GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Notice Bulletin Board History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Chip(
                        label: Text('${webVm.noticesList.length} Announcements'),
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                        labelStyle: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  webVm.noticesList.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            child: Text('No announcements published yet.', style: TextStyle(color: Colors.grey)),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: webVm.noticesList.length,
                          separatorBuilder: (context, index) => const Divider(height: 24),
                          itemBuilder: (context, index) {
                            final notice = webVm.noticesList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(notice.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: notice.type == 'Urgent' ? AppColors.error : AppColors.primaryBlue,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  notice.type,
                                                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Published on: ${notice.createdDate.day}/${notice.createdDate.month}/${notice.createdDate.year} by ${notice.sender}',
                                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      onPressed: () async {
                                        await webVm.deleteNotice(notice.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Announcement deleted successfully.')),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  notice.content,
                                  style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
                                ),
                              ],
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SUB SCREEN 10: STORY PANEL
// ==========================================
class StoryUploadPanel extends StatefulWidget {
  final bool isDark;

  const StoryUploadPanel({super.key, required this.isDark});

  @override
  State<StoryUploadPanel> createState() => _StoryUploadPanelState();
}

class _StoryUploadPanelState extends State<StoryUploadPanel> {
  final _textController = TextEditingController();

  void _onPublishStory() {
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);
    final story = Story(
      id: 'st_${DateTime.now().millisecondsSinceEpoch}',
      mediaUrl: 'https://images.unsplash.com/photo-1546410531-bb4caa6b424d',
      mediaType: 'image',
      text: _textController.text.trim(),
      uploadedBy: 'web_admin',
      uploaderName: 'Admin',
      durationSeconds: 5,
      createdDate: DateTime.now(),
    );

    webVm.uploadStory(story);
    _textController.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visual story uploaded (Expires in 24 hours).')));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: MaxWidthContainer(
        child: GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Upload Classroom Story Banner', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _textController,
                labelText: 'Story Caption / Text Overlay',
                hintText: 'Science Fair preparations are in progress! 🧪',
                prefixIcon: Icons.text_fields,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Upload Story Banner',
                onPressed: _onPublishStory,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SUB SCREEN 11: DOUBTS REPLY PANEL
// ==========================================
class DoubtPanel extends StatelessWidget {
  final bool isDark;

  const DoubtPanel({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final webVm = Provider.of<WebPanelViewModel>(context);

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: webVm.doubtQueries.length,
      itemBuilder: (context, index) {
        final query = webVm.doubtQueries[index];
        final bool isPending = query['status'] == 'Pending';

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${query['studentName']} (${query['class']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPending ? AppColors.secondaryOrange.withOpacity(0.12) : AppColors.accentGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        query['status'],
                        style: TextStyle(
                          color: isPending ? AppColors.secondaryOrange : AppColors.accentGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Subject: ${query['subject']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                Text('Question: "${query['question']}"', style: const TextStyle(fontWeight: FontWeight.w600, fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
                
                if (isPending) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => webVm.replyToDoubt(query['id'], 'An explanation note was updated in Notes library.'),
                          child: const Text('Send Quick Explanation'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => webVm.forwardDoubt(query['id']),
                          child: const Text('Forward to Administrator'),
                        ),
                      ),
                    ],
                  )
                ] else ...[
                  Text('Solution Sent: "${query['replyText']}"', style: const TextStyle(color: AppColors.accentGreen, fontSize: 13)),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// SUB SCREEN 12: TARGETED PUSH NOTIFICATIONS
// ==========================================
class NotificationsPanel extends StatefulWidget {
  final bool isDark;

  const NotificationsPanel({super.key, required this.isDark});

  @override
  State<NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  
  String _targetType = 'all';

  void _onSend() {
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);
    webVm.sendPushNotification(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      targetType: _targetType,
    );

    _titleController.clear();
    _bodyController.clear();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Targeted push notifications dispatched.')));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: MaxWidthContainer(
        child: GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Send Push Notifications (FCM)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Target Audience: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _targetType,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Users')),
                      DropdownMenuItem(value: 'class', child: Text('Class 5 Students')),
                      DropdownMenuItem(value: 'role', child: Text('Teachers Only')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _targetType = val);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _titleController,
                labelText: 'Notification Title',
                hintText: 'e.g. Urgent Exam Postponement',
                prefixIcon: Icons.notification_important,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _bodyController,
                labelText: 'Message Body Text',
                hintText: 'The scheduled Math test is postponed to...',
                prefixIcon: Icons.message,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Send Push Notifications',
                onPressed: _onSend,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SUB SCREEN 13: REPORTS PANEL
// ==========================================
class ReportsPanel extends StatelessWidget {
  final bool isDark;

  const ReportsPanel({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(24),
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildReportButton('Student Attendance Report', Icons.calendar_today),
        _buildReportButton('Homework Completion Logs', Icons.assignment),
        _buildReportButton('Quiz Performance Leaderboard', Icons.quiz),
      ],
    );
  }

  Widget _buildReportButton(String title, IconData icon) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primaryBlue, size: 32),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text('Download PDF Report', style: TextStyle(color: AppColors.secondaryOrange, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SUB SCREEN 14: SETTINGS PANEL
// ==========================================
class WebSettingsPanel extends StatefulWidget {
  final bool isDark;

  const WebSettingsPanel({super.key, required this.isDark});

  @override
  State<WebSettingsPanel> createState() => _WebSettingsPanelState();
}

class _WebSettingsPanelState extends State<WebSettingsPanel> {
  final _schoolController = TextEditingController(text: 'Agarwal Knowledge Hub');
  final _addressController = TextEditingController(text: 'Mithapur, Patna, Bihar');
  final _emailController = TextEditingController(text: 'info@agarwalknowledgehub.com');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: MaxWidthContainer(
        child: GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Configure Hub Settings Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _schoolController,
                labelText: 'School Name Title',
                hintText: 'Agarwal Knowledge Hub',
                prefixIcon: Icons.school,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _addressController,
                labelText: 'Postal Address',
                hintText: 'Patna, Bihar',
                prefixIcon: Icons.map,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: 'Contact Email Address',
                hintText: 'info@agarwal.com',
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Save System Changes',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('System configuration settings saved.')));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// COMPANION WIDGET: MAX WIDTH CONTAINER
// ==========================================
class MaxWidthContainer extends StatelessWidget {
  final Widget child;

  const MaxWidthContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: child,
      ),
    );
  }
}

// ==========================================
// NEW FEATURE SUB PANEL: GENERIC ROLE PANEL
// ==========================================
class GenericRolePanel extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isDark;

  const GenericRolePanel({
    super.key,
    required this.title,
    required this.icon,
    required this.isDark,
  });

  @override
  State<GenericRolePanel> createState() => _GenericRolePanelState();
}

class _GenericRolePanelState extends State<GenericRolePanel> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> _getSimulatedData() {
    switch (widget.title) {
      case 'Parent Management':
        return [
          {'name': 'Sanjay Agarwal', 'child': 'Narayan Agarwal', 'class': 'Class 5', 'phone': '+919876543211', 'email': 'sanjay@agarwal.com', 'status': 'Active'},
          {'name': 'Ramesh Kumar', 'child': 'Amit Kumar', 'class': 'Class 8', 'phone': '+919876543233', 'email': 'ramesh@kumar.com', 'status': 'Active'},
          {'name': 'Sunita Devi', 'child': 'Neha Kumari', 'class': 'Class 3', 'phone': '+919876543255', 'email': 'sunita@devi.com', 'status': 'Active'},
        ];
      case 'School & Branches':
        return [
          {'name': 'Patna Main Branch', 'code': 'PAT-001', 'address': 'Mithapur, Patna', 'head': 'Director Agarwal', 'phone': '+919876543299', 'status': 'Primary'},
          {'name': 'Ranchi Extension', 'code': 'RAN-002', 'address': 'Lalpur, Ranchi', 'head': 'A. K. Roy', 'phone': '+919876543288', 'status': 'Active'},
          {'name': 'Gaya Branch', 'code': 'GAY-003', 'address': 'Gaya Chowk, Gaya', 'head': 'S. P. Singh', 'phone': '+919876543277', 'status': 'Active'},
        ];
      case 'Section Management':
        return [
          {'name': 'Section A', 'class': 'Class 5', 'room': 'Room 12', 'strength': '40 Students', 'teacher': 'Nisha Gupta', 'status': 'Full'},
          {'name': 'Section B', 'class': 'Class 5', 'room': 'Room 14', 'strength': '35 Students', 'teacher': 'Ravi Kant', 'status': 'Active'},
          {'name': 'Section A', 'class': 'Class 8', 'room': 'Room 20', 'strength': '45 Students', 'teacher': 'S. Kumar', 'status': 'Full'},
        ];
      case 'Events & Gallery':
        return [
          {'name': 'Annual Sports Day 2026', 'date': '2026-11-20', 'venue': 'Main Stadium', 'cost': 'Free', 'coordinator': 'Ravi Kant', 'status': 'Upcoming'},
          {'name': 'Science Exhibition', 'date': '2026-08-15', 'venue': 'Auditorium', 'cost': '₹50/entry', 'coordinator': 'Nisha Gupta', 'status': 'Scheduled'},
          {'name': 'Independance Day Gala', 'date': '2026-08-15', 'venue': 'Assembly Ground', 'cost': 'Free', 'coordinator': 'Principal', 'status': 'Planned'},
        ];
      case 'Certificates':
        return [
          {'name': 'Academic Excellence Award', 'issuedTo': 'Narayan Agarwal', 'class': 'Class 5', 'date': '2026-06-12', 'designation': 'Scholarship', 'status': 'Generated'},
          {'name': 'Sports Champion Medal', 'issuedTo': 'Amit Kumar', 'class': 'Class 8', 'date': '2026-06-10', 'designation': 'Sports', 'status': 'Printed'},
          {'name': 'Perfect Attendance cert', 'issuedTo': 'Neha Kumari', 'class': 'Class 3', 'date': '2026-05-30', 'designation': 'Attendance', 'status': 'Generated'},
        ];
      case 'Fee Collection':
      case 'Fee Management':
      case 'Student Fees':
      case 'Staff Salary':
      case 'Income':
      case 'Expenses':
      case 'Invoices & Receipts':
      case 'Payment History':
        return [
          {'transaction': 'TXN-984210', 'student': 'Narayan Agarwal', 'class': 'Class 5', 'amount': '₹4,500', 'date': '2026-08-01', 'method': 'UPI (PhonePe)', 'status': 'Paid'},
          {'transaction': 'TXN-984211', 'student': 'Amit Kumar', 'class': 'Class 8', 'amount': '₹5,200', 'date': '2026-08-03', 'method': 'NetBanking', 'status': 'Paid'},
          {'transaction': 'TXN-984212', 'student': 'Neha Kumari', 'class': 'Class 3', 'amount': '₹4,500', 'date': '2026-08-05', 'method': 'Cash', 'status': 'Pending'},
        ];
      default:
        return [
          {'detail_1': 'Operational Record 1', 'detail_2': 'System Administration', 'detail_3': 'Supervised', 'status': 'Completed'},
          {'detail_1': 'Operational Record 2', 'detail_2': 'Academic Management', 'detail_3': 'Pending', 'status': 'In-Progress'},
          {'detail_1': 'Operational Record 3', 'detail_2': 'Institution ERP Sync', 'detail_3': 'Automatic', 'status': 'Completed'},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;
    final List<Map<String, String>> records = _getSimulatedData();
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isMobile = screenWidth < 700;

    final Color accentColor = widget.title.contains('Fee') || widget.title.contains('Salary') || widget.title.contains('Income') || widget.title.contains('Expenses')
        ? Colors.green
        : widget.title.contains('Event') || widget.title.contains('Gallery') || widget.title.contains('Certificate')
            ? AppColors.secondaryOrange
            : AppColors.primaryBlue;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Responsive Glassmorphic Header Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: isMobile ? 16 : 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor.withOpacity(0.85), accentColor.withOpacity(0.55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: isMobile ? 22 : 28,
                      backgroundColor: Colors.white24,
                      child: Icon(widget.icon, color: Colors.white, size: isMobile ? 22 : 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: isMobile ? 18 : 22,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ERP System Module Active Sync',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isMobile) const SizedBox(height: 16),
                if (!isMobile) const Spacer(),
                SizedBox(
                  width: isMobile ? double.infinity : null,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: accentColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.title} details refreshed! 🔄')),
                      );
                    },
                    icon: const Icon(Icons.refresh, size: 14),
                    label: const Text('Sync Module', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Responsive Stats Row: Wrap in GridView with adaptive crossAxisCount
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isMobile ? 3.5 : 2.8,
            children: [
              _buildStatsCard('Total Items Sync', '${records.length}', Icons.sync, Colors.blue, isMobile),
              _buildStatsCard('Operational Status', 'Optimal', Icons.check_circle_outline, Colors.green, isMobile),
              _buildStatsCard('Encryption Keys', 'AES-256 Enabled', Icons.security, Colors.orange, isMobile),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Responsive Data Table Panel
          Container(
            decoration: BoxDecoration(
              color: isDark ? null : Colors.white,
              gradient: isDark
                  ? LinearGradient(
                      colors: [
                        AppColors.primaryBlue.withOpacity(0.12),
                        AppColors.primaryBlue.withOpacity(0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.primaryBlue.withOpacity(0.25) : Colors.grey.shade100,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            padding: EdgeInsets.all(isMobile ? 14 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Responsive Search & Filter header
                Flex(
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Operational Logs & Records',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                    if (isMobile) const SizedBox(height: 12),
                    if (!isMobile) const Spacer(),
                    SizedBox(
                      width: isMobile ? double.infinity : 260,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search items...',
                          prefixIcon: const Icon(Icons.search, size: 18),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Data List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: records.length,
                  separatorBuilder: (c, i) => const Divider(height: 16),
                  itemBuilder: (context, idx) {
                    final item = records[idx];
                    final keys = item.keys.toList();
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: accentColor.withOpacity(0.1),
                        child: Icon(widget.icon, color: accentColor, size: 18),
                      ),
                      title: Text(
                        item[keys[0]] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          keys.length > 1 ? '${keys[1].toUpperCase()}: ${item[keys[1]]}\n${keys[2].toUpperCase()}: ${item[keys[2]]}' : '',
                          style: TextStyle(color: isDark ? Colors.grey : Colors.grey.shade600, fontSize: 11),
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (item['status'] == 'Active' || item['status'] == 'Paid' || item['status'] == 'Generated' || item['status'] == 'Completed' || item['status'] == 'Primary')
                              ? Colors.green.withOpacity(0.15)
                              : Colors.orange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['status'] ?? 'Active',
                          style: TextStyle(
                            color: (item['status'] == 'Active' || item['status'] == 'Paid' || item['status'] == 'Generated' || item['status'] == 'Completed' || item['status'] == 'Primary')
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String count, IconData icon, Color color, bool isMobile) {
    final bool isDark = widget.isDark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? null : Colors.white,
        gradient: isDark
            ? LinearGradient(
                colors: [
                  color.withOpacity(0.18),
                  color.withOpacity(0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? color.withOpacity(0.25) : Colors.grey.shade100,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.12),
            offset: const Offset(0, 4),
            blurRadius: 10,
          )
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 10 : 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: isDark ? Colors.white : color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// SUB SCREEN: PARENT MANAGEMENT PANEL
// ==========================================
class ParentManagementPanel extends StatefulWidget {
  final bool isDark;
  const ParentManagementPanel({super.key, required this.isDark});

  @override
  State<ParentManagementPanel> createState() => _ParentManagementPanelState();
}

class _ParentManagementPanelState extends State<ParentManagementPanel> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showParentActivityDialog(BuildContext context, UserProfile parent) {
    showDialog(
      context: context,
      builder: (ctx) {
        final lastActiveStr = parent.isOnline 
            ? 'Active Now' 
            : '${DateTime.now().difference(parent.lastActive).inMinutes} mins ago';
        return AlertDialog(
          title: Text('${parent.name} - Activity Logs'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Role: Parent'),
              const SizedBox(height: 6),
              Text('Associated Child: ${parent.parentName}'),
              const SizedBox(height: 6),
              Text('Last Active: $lastActiveStr'),
              const SizedBox(height: 6),
              Text('Online Status: ${parent.isOnline ? "Online 🟢" : "Offline ⚪"}'),
              const SizedBox(height: 6),
              Text('Account Status: ${parent.isBlocked ? "Blocked ⛔" : "Active ✅"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  void _showEditParentDialog(BuildContext context, UserProfile parent) {
    final nameCtrl = TextEditingController(text: parent.name);
    final phoneCtrl = TextEditingController(text: parent.phone);
    final emailCtrl = TextEditingController(text: parent.email);
    final addressCtrl = TextEditingController(text: parent.address);
    final childNameCtrl = TextEditingController(text: parent.parentName);
    final childPhoneCtrl = TextEditingController(text: parent.parentMobile);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.edit_outlined, color: AppColors.primaryBlue),
            const SizedBox(width: 10),
            const Text('Edit Parent Details'),
          ],
        ),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: nameCtrl,
                  labelText: 'Parent Name',
                  hintText: 'e.g. Sanjay Agarwal',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: phoneCtrl,
                  labelText: 'Parent Mobile',
                  hintText: 'e.g. +919876543211',
                  prefixIcon: Icons.phone_android_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: emailCtrl,
                  labelText: 'Email Address',
                  hintText: 'e.g. parent@gmail.com',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: addressCtrl,
                  labelText: 'Address',
                  hintText: 'e.g. Mithapur, Patna',
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: childNameCtrl,
                  labelText: 'Child Name',
                  hintText: 'e.g. Narayan Agarwal',
                  prefixIcon: Icons.child_care,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: childPhoneCtrl,
                  labelText: 'Child Mobile',
                  hintText: 'e.g. +919876543210',
                  prefixIcon: Icons.phone_callback,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final updated = parent.copyWith(
                name: nameCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                address: addressCtrl.text.trim(),
                parentName: childNameCtrl.text.trim(),
                parentMobile: childPhoneCtrl.text.trim(),
              );
              Provider.of<WebPanelViewModel>(context, listen: false).updateStudent(updated);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Details of ${parent.name} updated successfully! 🔄')),
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final webVm = Provider.of<WebPanelViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context);
    final isSuperAdmin = authVm.userProfile?.role == AppStrings.roleSuperAdmin;

    final filteredParents = webVm.parentsList.where((p) {
      final query = _searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(query) ||
          p.phone.contains(query) ||
          p.parentName.toLowerCase().contains(query);
    }).toList();

    final int totalCount = webVm.parentsList.length;
    final int onlineCount = webVm.parentsList.where((p) => p.isOnline).length;
    final int offlineCount = webVm.parentsList.where((p) => !p.isOnline).length;
    final int blockedCount = webVm.parentsList.where((p) => p.isBlocked).length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Banner Card with Sync Module
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.family_restroom, size: 36, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Parent Management',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ERP System Module Active Sync',
                              style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1E3C72),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.sync, size: 16),
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Starting Parent ERP Database Active Sync... 🔄')),
                          );
                          int syncCount = 0;
                          for (final student in webVm.studentsList) {
                            if (student.parentName.trim().isNotEmpty && student.parentMobile.trim().isNotEmpty) {
                              await webVm._syncParentForStudent(student);
                              syncCount++;
                            }
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Success! Sync Complete. $syncCount Parent profiles linked! ✅')),
                          );
                        },
                        label: const Text('Sync Module', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

                // Top Live Active Surveillance Counter Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: widget.isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniStat('Total Parents', '$totalCount', Icons.people, AppColors.primaryBlue),
                      _buildMiniStat('Live Active 🟢', '$onlineCount', Icons.sensors, Colors.green),
                      _buildMiniStat('Offline ⚪', '$offlineCount', Icons.sensors_off, Colors.grey),
                      _buildMiniStat('Blocked ⛔', '$blockedCount', Icons.block, Colors.red),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Parent Roster & Activity Surveillance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    if (isSuperAdmin)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'Super Admin Surveillance Controls Active 🛠️',
                          style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search parents by name, mobile, or child name...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                ),
                const SizedBox(height: 16),

                if (filteredParents.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_outline, size: 48, color: Colors.grey.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            'No parents registered or matching your search criteria.',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredParents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final parent = filteredParents[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: widget.isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: parent.isBlocked 
                                ? Colors.red.withOpacity(0.3) 
                                : (parent.isOnline ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2)),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: parent.isOnline ? Colors.green : Colors.grey,
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.family_restroom),
                          ),
                          title: Row(
                            children: [
                              Text(parent.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              if (parent.isBlocked)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Suspended 🚫',
                                    style: TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                )
                              else if (parent.isOnline)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Active Live 🟢',
                                    style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Offline ⚪',
                                    style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text('Child: ${parent.parentName} | Phone: ${parent.phone} | Class: ${parent.userClass}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility_outlined, color: AppColors.primaryBlue),
                                tooltip: 'View Activity Logs',
                                onPressed: () => _showParentActivityDialog(context, parent),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                tooltip: 'Edit Details',
                                onPressed: () => _showEditParentDialog(context, parent),
                              ),

                              if (isSuperAdmin) ...[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: parent.isBlocked ? Colors.green : Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    final updated = parent.copyWith(
                                      isBlocked: !parent.isBlocked,
                                      isOnline: !parent.isBlocked ? false : parent.isOnline,
                                    );
                                    webVm.updateStudent(updated);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(parent.isBlocked ? '${parent.name} Unblocked!' : '${parent.name} Blocked!'),
                                      ),
                                    );
                                  },
                                  child: Text(parent.isBlocked ? 'Unblock' : 'Block', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade700,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    final updated = parent.copyWith(
                                      forceLogout: true,
                                      isOnline: false,
                                    );
                                    webVm.updateStudent(updated);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Force Logout command sent to ${parent.name}\'s active sessions!'),
                                        backgroundColor: Colors.orange.shade700,
                                      ),
                                    );
                                  },
                                  child: const Text('Force Logout', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ],

                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                onPressed: () => webVm.deleteStudent(parent.uid),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
