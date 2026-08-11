import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/academic_provider.dart';
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
import '../../../settings/viewmodels/settings_viewmodel.dart';
import '../../../../core/services/enterprise_provider.dart';
import '../../../../core/models/system_settings.dart';
import '../../../../core/models/audit_log.dart';
import 'package:universal_html/html.dart' as html;

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
      case 'Section Management':
        return SectionManagementPanel(isDark: isDark);
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
  final Set<String> _selectedUids = {};

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

  void _showStatsSummaryDialog(BuildContext outerContext, String type) {
    final bool isDark = widget.isDark;
    final webVm = Provider.of<WebPanelViewModel>(outerContext, listen: false);

    List<UserProfile> studentsList;
    if (type == 'Total Students') {
      studentsList = webVm.studentsList;
    } else if (type == 'Live Active') {
      studentsList = webVm.studentsList.where((s) => s.isOnline).toList();
    } else if (type == 'Offline') {
      studentsList = webVm.studentsList.where((s) => !s.isOnline).toList();
    } else {
      studentsList = webVm.studentsList.where((s) => s.isBlocked).toList();
    }

    showDialog(
      context: outerContext,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (statefulCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  Icon(
                    type == 'Blocked'
                        ? Icons.block
                        : (type == 'Live Active' ? Icons.sensors : Icons.people),
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Text('$type List (${studentsList.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              content: SizedBox(
                width: 400,
                height: 300,
                child: studentsList.isEmpty
                    ? Center(child: Text('No students found for: $type'))
                    : ListView.separated(
                        itemCount: studentsList.length,
                        separatorBuilder: (c, i) => const Divider(),
                        itemBuilder: (listCtx, index) {
                          final student = studentsList[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text('Class: ${student.userClass} | Phone: ${student.phone}', style: const TextStyle(fontSize: 11)),
                            trailing: type == 'Blocked'
                                ? TextButton(
                                    onPressed: () async {
                                      final updated = student.copyWith(isBlocked: false);
                                      await Provider.of<WebPanelViewModel>(outerContext, listen: false).updateStudent(updated);
                                      setDialogState(() {
                                        studentsList.removeAt(index);
                                      });
                                      setState(() {});
                                      ScaffoldMessenger.of(outerContext).showSnackBar(
                                        SnackBar(content: Text('${student.name} unblocked successfully! 🔓')),
                                      );
                                    },
                                    child: const Text('Unblock', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  )
                                : Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: student.isOnline ? Colors.green : Colors.grey,
                                    ),
                                  ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
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
                      GestureDetector(
                        onTap: () => _showStatsSummaryDialog(context, 'Total Students'),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: _buildMiniStat('Total Students', '$totalCount', Icons.people, AppColors.primaryBlue),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showStatsSummaryDialog(context, 'Live Active'),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: _buildMiniStat('Live Active 🟢', '$onlineCount', Icons.sensors, Colors.green),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showStatsSummaryDialog(context, 'Offline'),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: _buildMiniStat('Offline ⚪', '$offlineCount', Icons.sensors_off, Colors.grey),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showStatsSummaryDialog(context, 'Blocked'),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: _buildMiniStat('Blocked ⛔', '$blockedCount', Icons.block, Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: webVm.studentsList.isNotEmpty && _selectedUids.length == webVm.studentsList.length,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedUids.addAll(webVm.studentsList.map((s) => s.uid));
                              } else {
                                _selectedUids.clear();
                              }
                            });
                          },
                        ),
                        const Text('Select All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 16),
                        const Text('Student Roster & Activity Surveillance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Row(
                      children: [
                        if (_selectedUids.isNotEmpty) ...[
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.delete_sweep, size: 18),
                            label: Text('Delete Selected (${_selectedUids.length})'),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (confirmCtx) => AlertDialog(
                                  title: const Text('Confirm Bulk Deletion'),
                                  content: Text('Are you sure you want to delete ${_selectedUids.length} selected students? They will be moved to Delete History.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(confirmCtx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(confirmCtx, true),
                                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                                      child: const Text('Move to History'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                final selectedStudents = webVm.studentsList.where((s) => _selectedUids.contains(s.uid)).toList();
                                for (final student in selectedStudents) {
                                  await webVm.moveToTrash(student);
                                }
                                setState(() {
                                  _selectedUids.clear();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Selected students moved to Delete History! 🗑️')),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                        ],
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.history, size: 18),
                          label: const Text('Delete History'),
                          onPressed: () => _showDeleteHistoryDialog(context, AppStrings.roleStudent, webVm),
                        ),
                        if (isSuperAdmin) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: const Text('Super Admin Active 🛡️', 
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ],
                      ],
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
                      final isSelected = _selectedUids.contains(student.uid);
                      return ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: isSelected,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedUids.add(student.uid);
                                  } else {
                                    _selectedUids.remove(student.uid);
                                  }
                                });
                              },
                            ),
                            const SizedBox(width: 4),
                            Stack(
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
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (confirmCtx) => AlertDialog(
                                    title: const Text('Confirm Deletion'),
                                    content: Text('Are you sure you want to delete ${student.name}? They will be moved to Delete History.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(confirmCtx, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(confirmCtx, true),
                                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                                        child: const Text('Move to History'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await webVm.moveToTrash(student);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${student.name} moved to Delete History! 🗑️')),
                                  );
                                }
                              },
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
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final Set<String> _selectedUids = {};

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _onAddTeacher() {
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);
    final emailVal = _emailController.text.trim().toLowerCase();
    
    if (emailVal.isEmpty || !emailVal.contains('@') || !emailVal.contains('.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Access Denied: Please enter a valid Email address for the teacher'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final teacher = UserProfile(
      uid: 'tch_${DateTime.now().millisecondsSinceEpoch}',
      role: AppStrings.roleTeacher,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: emailVal,
      address: '',
      userClass: _subjectController.text.trim(),
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
    _emailController.clear();
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

  void _showEditTeacherDialog(BuildContext context, UserProfile teacher) {
    final nameCtrl = TextEditingController(text: teacher.name);
    final phoneCtrl = TextEditingController(text: teacher.phone);
    final emailCtrl = TextEditingController(text: teacher.email);
    final addressCtrl = TextEditingController(text: teacher.address);
    final idCtrl = TextEditingController(text: teacher.admissionNumber);
    final classCtrl = TextEditingController(text: teacher.userClass);
    final genderCtrl = TextEditingController(text: teacher.gender);
    final dobCtrl = TextEditingController(text: teacher.dob);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.edit_outlined, color: AppColors.primaryBlue),
            const SizedBox(width: 10),
            const Text('Edit Teacher Details'),
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
                  labelText: 'Teacher Name',
                  hintText: 'e.g. Ms. Anjali Verma',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: phoneCtrl,
                  labelText: 'Mobile Number',
                  hintText: 'e.g. +919876543222',
                  prefixIcon: Icons.phone_android_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: emailCtrl,
                  labelText: 'Email Address',
                  hintText: 'e.g. teacher@gmail.com',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: addressCtrl,
                  labelText: 'Address',
                  hintText: 'e.g. Patna',
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: idCtrl,
                  labelText: 'Teacher ID / Code',
                  hintText: 'e.g. TCH04',
                  prefixIcon: Icons.badge_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: classCtrl,
                  labelText: 'Class Assignment / Subjects',
                  hintText: 'e.g. Mathematics, Science',
                  prefixIcon: Icons.subject_outlined,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: genderCtrl,
                  labelText: 'Gender',
                  hintText: 'e.g. Female / Male',
                  prefixIcon: Icons.people_outline,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: dobCtrl,
                  labelText: 'Date of Birth',
                  hintText: 'e.g. 1994-04-12',
                  prefixIcon: Icons.calendar_today_outlined,
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
              final updated = teacher.copyWith(
                name: nameCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                address: addressCtrl.text.trim(),
                admissionNumber: idCtrl.text.trim(),
                userClass: classCtrl.text.trim(),
                gender: genderCtrl.text.trim(),
                dob: dobCtrl.text.trim(),
              );
              Provider.of<WebPanelViewModel>(context, listen: false).updateTeacher(updated);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Details of ${teacher.name} updated successfully! 🔄')),
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
                    Row(
                      children: [
                        Checkbox(
                          value: webVm.teachersList.isNotEmpty && _selectedUids.length == webVm.teachersList.length,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedUids.addAll(webVm.teachersList.map((t) => t.uid));
                              } else {
                                _selectedUids.clear();
                              }
                            });
                          },
                        ),
                        const Text('Select All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 16),
                        const Text('Teachers Roster & Active Class Surveillance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Row(
                      children: [
                        if (_selectedUids.isNotEmpty) ...[
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.delete_sweep, size: 18),
                            label: Text('Delete Selected (${_selectedUids.length})'),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (confirmCtx) => AlertDialog(
                                  title: const Text('Confirm Bulk Deletion'),
                                  content: Text('Are you sure you want to delete ${_selectedUids.length} selected teachers? They will be moved to Delete History.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(confirmCtx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(confirmCtx, true),
                                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                                      child: const Text('Move to History'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                final selectedTeachers = webVm.teachersList.where((t) => _selectedUids.contains(t.uid)).toList();
                                for (final t in selectedTeachers) {
                                  await webVm.moveToTrash(t);
                                }
                                setState(() {
                                  _selectedUids.clear();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Selected teachers moved to Delete History! 🗑️')),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                        ],
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.history, size: 18),
                          label: const Text('Delete History'),
                          onPressed: () => _showDeleteHistoryDialog(context, AppStrings.roleTeacher, webVm),
                        ),
                        if (isSuperAdmin) ...[
                          const SizedBox(width: 12),
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
                      ],
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

                      final isSelected = _selectedUids.contains(teacher.uid);
                      return ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: isSelected,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedUids.add(teacher.uid);
                                  } else {
                                    _selectedUids.remove(teacher.uid);
                                  }
                                });
                              },
                            ),
                            const SizedBox(width: 4),
                            Stack(
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
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                              tooltip: 'Edit Teacher Details',
                              onPressed: () => _showEditTeacherDialog(context, teacher),
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
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (confirmCtx) => AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: Text('Are you sure you want to delete ${teacher.name}? They will be moved to Delete History.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(confirmCtx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(confirmCtx, true),
                                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                                          child: const Text('Move to History'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await webVm.moveToTrash(teacher);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${teacher.name} moved to Delete History! 🗑️')),
                                    );
                                  }
                                },
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
                controller: _emailController,
                labelText: 'Email Address',
                hintText: 'e.g. teacher@gmail.com',
                prefixIcon: Icons.email_outlined,
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
class ClassSubjectPanel extends StatefulWidget {
  final bool isDark;
  const ClassSubjectPanel({super.key, required this.isDark});

  @override
  State<ClassSubjectPanel> createState() => _ClassSubjectPanelState();
}

class _ClassSubjectPanelState extends State<ClassSubjectPanel> {
  final TextEditingController _classSearchController = TextEditingController();
  final TextEditingController _subjectSearchController = TextEditingController();

  List<String> _classes = [
    'CBSE Nursery-5',
    'BSEB Class 1-7',
    'Computer Science',
    'Class 8',
    'Class 9',
    'Class 10',
    'Class 11',
    'Class 12',
  ];

  List<String> _subjects = [
    'Mathematics',
    'English Grammar',
    'Computer Theory',
    'Computer Practical',
    'Physics',
    'Chemistry',
    'Biology',
    'Social Science',
  ];

  @override
  void initState() {
    super.initState();
    _classSearchController.addListener(() => setState(() {}));
    _subjectSearchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _classSearchController.dispose();
    _subjectSearchController.dispose();
    super.dispose();
  }

  void _showAddClassDialog({String? existingClass, int? index}) {
    final bool isDark = widget.isDark;
    final controller = TextEditingController(text: existingClass ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            existingClass != null ? 'Edit Class' : 'Add New Class',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter class name (e.g. CBSE Class 10)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) return;
                setState(() {
                  if (existingClass != null && index != null) {
                    _classes[index] = text;
                  } else {
                    _classes.add(text);
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(existingClass != null ? 'Class updated! 💾' : 'New Class added! 🎉'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(existingClass != null ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSubjectDialog({String? existingSubject, int? index}) {
    final bool isDark = widget.isDark;
    final controller = TextEditingController(text: existingSubject ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            existingSubject != null ? 'Edit Subject' : 'Add New Subject',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter subject name (e.g. Science)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) return;
                setState(() {
                  if (existingSubject != null && index != null) {
                    _subjects[index] = text;
                  } else {
                    _subjects.add(text);
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(existingSubject != null ? 'Subject updated! 💾' : 'New Subject added! 🎉'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(existingSubject != null ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isMobile = screenWidth < 700;

    final String classQuery = _classSearchController.text.toLowerCase();
    final List<String> filteredClasses = _classes
        .where((c) => c.toLowerCase().contains(classQuery))
        .toList();

    final String subjectQuery = _subjectSearchController.text.toLowerCase();
    final List<String> filteredSubjects = _subjects
        .where((s) => s.toLowerCase().contains(subjectQuery))
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue.withOpacity(0.85), AppColors.primaryBlue.withOpacity(0.55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.class_outlined, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Classes & Subjects Management',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Define academic branches, class standards, and subject curriculum for school records.',
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isMobile ? 4 : 3.5,
            children: [
              _buildStatsSummaryCard('Total Active Classes', '${_classes.length}', Icons.school, Colors.blue),
              _buildStatsSummaryCard('Total Course Subjects', '${_subjects.length}', Icons.book, Colors.green),
            ],
          ),
          
          const SizedBox(height: 24),

          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: isMobile ? 0 : 1,
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Active Classes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onPressed: () => _showAddClassDialog(),
                            icon: const Icon(Icons.add, size: 12),
                            label: const Text('Add Class', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _classSearchController,
                        decoration: InputDecoration(
                          hintText: 'Search classes...',
                          prefixIcon: const Icon(Icons.search, size: 16),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredClasses.length,
                        separatorBuilder: (c, i) => const Divider(height: 8),
                        itemBuilder: (context, idx) {
                          final className = filteredClasses[idx];
                          final originalIndex = _classes.indexOf(className);
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              child: const Icon(Icons.grade, color: Colors.blue, size: 14),
                            ),
                            title: Text(className, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.green),
                                  onPressed: () => _showAddClassDialog(existingClass: className, index: originalIndex),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _classes.removeAt(originalIndex);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$className deleted!'),
                                        action: SnackBarAction(
                                          label: 'UNDO',
                                          onPressed: () {
                                            setState(() {
                                              _classes.insert(originalIndex, className);
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              if (isMobile) const SizedBox(height: 20) else const SizedBox(width: 24),
              
              Expanded(
                flex: isMobile ? 0 : 1,
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Course Subjects', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onPressed: () => _showAddSubjectDialog(),
                            icon: const Icon(Icons.add, size: 12),
                            label: const Text('Add Subject', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _subjectSearchController,
                        decoration: InputDecoration(
                          hintText: 'Search subjects...',
                          prefixIcon: const Icon(Icons.search, size: 16),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredSubjects.length,
                        separatorBuilder: (c, i) => const Divider(height: 8),
                        itemBuilder: (context, idx) {
                          final subjectName = filteredSubjects[idx];
                          final originalIndex = _subjects.indexOf(subjectName);
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.green.withOpacity(0.1),
                              child: const Icon(Icons.menu_book, color: Colors.green, size: 14),
                            ),
                            title: Text(subjectName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.green),
                                  onPressed: () => _showAddSubjectDialog(existingSubject: subjectName, index: originalIndex),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _subjects.removeAt(originalIndex);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$subjectName deleted!'),
                                        action: SnackBarAction(
                                          label: 'UNDO',
                                          onPressed: () {
                                            setState(() {
                                              _subjects.insert(originalIndex, subjectName);
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummaryCard(String title, String count, IconData icon, Color color) {
    final bool isDark = widget.isDark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? null : Colors.white,
        gradient: isDark
            ? LinearGradient(
                colors: [color.withOpacity(0.18), color.withOpacity(0.03)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? color.withOpacity(0.25) : Colors.grey.shade100,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                count,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
    }
}

// ==========================================
// SUB SCREEN 4B: SECTION MANAGEMENT PANEL
// ==========================================
class SectionManagementPanel extends StatefulWidget {
  final bool isDark;
  const SectionManagementPanel({super.key, required this.isDark});

  @override
  State<SectionManagementPanel> createState() => _SectionManagementPanelState();
}

class _SectionManagementPanelState extends State<SectionManagementPanel> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _sections = [
    {'name': 'Section A', 'class': 'Class 5', 'room': 'Room 12', 'strength': 40, 'teacher': 'Nisha Gupta', 'status': 'Full'},
    {'name': 'Section B', 'class': 'Class 5', 'room': 'Room 14', 'strength': 35, 'teacher': 'Ravi Kant', 'status': 'Active'},
    {'name': 'Section A', 'class': 'Class 8', 'room': 'Room 20', 'strength': 45, 'teacher': 'S. Kumar', 'status': 'Full'},
    {'name': 'Section C', 'class': 'Class 6', 'room': 'Room 08', 'strength': 28, 'teacher': 'Anjali Sharma', 'status': 'Active'},
  ];

  List<Map<String, dynamic>> _deletedSections = [];

  final List<String> _classesList = [
    'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'
  ];

  final List<String> _teachersList = [
    'Nisha Gupta', 'Ravi Kant', 'S. Kumar', 'Anjali Sharma', 'Vivek Patel'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSectionsSummaryDialog() {
    final bool isDark = widget.isDark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(Icons.layers, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              const Text('Active Sections Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: SizedBox(
            width: 400,
            height: 300,
            child: ListView.separated(
              itemCount: _sections.length,
              separatorBuilder: (c, i) => const Divider(),
              itemBuilder: (context, index) {
                final sec = _sections[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${sec['class']} - ${sec['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('Teacher: ${sec['teacher']} | Room: ${sec['room']}', style: const TextStyle(fontSize: 11)),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showClassroomsDetailDialog() {
    final bool isDark = widget.isDark;
    final Map<String, List<Map<String, dynamic>>> roomMap = {};
    for (var sec in _sections) {
      final String room = sec['room'];
      if (!roomMap.containsKey(room)) {
        roomMap[room] = [];
      }
      roomMap[room]!.add(sec);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Icon(Icons.door_sliding, color: Colors.green),
              const SizedBox(width: 8),
              const Text('Classrooms In Use', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: SizedBox(
            width: 400,
            height: 300,
            child: roomMap.isEmpty
                ? const Center(child: Text('No classrooms currently in use.'))
                : ListView.separated(
                    itemCount: roomMap.keys.length,
                    separatorBuilder: (c, i) => const Divider(),
                    itemBuilder: (context, index) {
                      final String room = roomMap.keys.elementAt(index);
                      final List<Map<String, dynamic>> assigned = roomMap[room]!;
                      final sectionsNames = assigned.map((s) => '${s['class']} (${s['name']})').join(', ');
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.green.withOpacity(0.1),
                          child: const Icon(Icons.room, color: Colors.green, size: 14),
                        ),
                        title: Text(room, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text('Assigned Sections: $sectionsNames', style: const TextStyle(fontSize: 11)),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showStrengthDetailDialog() {
    final bool isDark = widget.isDark;
    int maxStrength = 0;
    String maxSec = '';
    for (var sec in _sections) {
      final int str = sec['strength'] as int;
      if (str > maxStrength) {
        maxStrength = str;
        maxSec = '${sec['class']} - ${sec['name']}';
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Icon(Icons.group, color: Colors.orange),
              const SizedBox(width: 8),
              const Text('Section Strength Capacity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: SizedBox(
            width: 400,
            height: 320,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (maxStrength > 0) ...[
                  Text(
                    'Highest Capacity Section: $maxSec ($maxStrength Students)',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 12),
                ],
                Expanded(
                  child: ListView.separated(
                    itemCount: _sections.length,
                    separatorBuilder: (c, i) => const Divider(),
                    itemBuilder: (context, index) {
                      final sec = _sections[index];
                      final int strength = sec['strength'] as int;
                      final double percent = (strength / 60).clamp(0.0, 1.0);
                      return Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text('${sec['class']} - ${sec['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                               Text('$strength/60 Students', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                             ],
                           ),
                           const SizedBox(height: 4),
                           LinearProgressIndicator(
                             value: percent,
                             backgroundColor: Colors.grey.withOpacity(0.2),
                             color: percent > 0.8 ? Colors.orange : Colors.green,
                             minHeight: 4,
                             borderRadius: BorderRadius.circular(4),
                           ),
                         ],
                       );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEditDialog({Map<String, dynamic>? existingSection, int? index}) {
    final bool isDark = widget.isDark;

    final nameController = TextEditingController(text: existingSection != null ? existingSection['name'] : '');
    final roomController = TextEditingController(text: existingSection != null ? existingSection['room'] : '');
    final strengthController = TextEditingController(text: existingSection != null ? existingSection['strength'].toString() : '30');

    String selectedClass = existingSection != null ? existingSection['class'] : _classesList.first;
    String selectedTeacher = existingSection != null ? existingSection['teacher'] : _teachersList.first;
    String selectedStatus = existingSection != null ? existingSection['status'] : 'Active';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  Icon(existingSection != null ? Icons.edit_note : Icons.add_circle_outline, color: AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    existingSection != null ? 'Edit Section Details' : 'Add New Section',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Section Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'e.g. Section A',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text('Map to Class', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedClass,
                            isExpanded: true,
                            items: _classesList.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() {
                                  selectedClass = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text('Room Number', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: roomController,
                        decoration: InputDecoration(
                          hintText: 'e.g. Room 12',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text('Student Capacity / Strength', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: strengthController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'e.g. 40',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text('Assign Class Teacher', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedTeacher,
                            isExpanded: true,
                            items: _teachersList.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() {
                                  selectedTeacher = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text('Capacity Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedStatus,
                            isExpanded: true,
                            items: ['Active', 'Full'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() {
                                  selectedStatus = val;
                                });
                              }
                            },
                          ),
                        ),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final String name = nameController.text.trim();
                    final String room = roomController.text.trim();
                    final int strength = int.tryParse(strengthController.text.trim()) ?? 30;

                    if (name.isEmpty || room.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill out all fields.'), backgroundColor: Colors.orange),
                      );
                      return;
                    }

                    final Map<String, dynamic> newSection = {
                      'name': name,
                      'class': selectedClass,
                      'room': room,
                      'strength': strength,
                      'teacher': selectedTeacher,
                      'status': selectedStatus,
                    };

                    setState(() {
                      if (existingSection != null && index != null) {
                        _sections[index] = newSection;
                      } else {
                        _sections.add(newSection);
                      }
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(existingSection != null ? 'Section updated! 💾' : 'New Section added! 🎉'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text(existingSection != null ? 'Save Changes' : 'Add Section'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTrashArchiveDialog() {
    final bool isDark = widget.isDark;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  const Icon(Icons.delete_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  const Text('Section Delete History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              content: SizedBox(
                width: 450,
                height: 350,
                child: _deletedSections.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_delete_outlined, size: 48, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('No deleted sections.'),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _deletedSections.length,
                        separatorBuilder: (c, i) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = _deletedSections[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('${item['class']} - ${item['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text('Teacher: ${item['teacher']} | Room: ${item['room']}', style: const TextStyle(fontSize: 11)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _sections.add(item);
                                      _deletedSections.removeAt(index);
                                    });
                                    setDialogState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Section restored! 🔄'), backgroundColor: Colors.green),
                                    );
                                  },
                                  icon: const Icon(Icons.restore, size: 14, color: Colors.green),
                                  label: const Text('Restore', style: TextStyle(color: Colors.green, fontSize: 11)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_forever, size: 18, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _deletedSections.removeAt(index);
                                    });
                                    setDialogState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Section permanently deleted! 🗑️'), backgroundColor: Colors.red),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
              ],
            );
          },
        );
      },
    );
  }

  void _showViewDetailsDialog(Map<String, dynamic> item) {
    final bool isDark = widget.isDark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              const Text('Section Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Section Name:', item['name']),
                _buildDetailRow('Assigned Class:', item['class']),
                _buildDetailRow('Room Number:', item['room']),
                _buildDetailRow('Student Capacity:', '${item['strength']} Students'),
                _buildDetailRow('Class Teacher:', item['teacher']),
                _buildDetailRow('Status:', item['status']),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
          ),
          Expanded(
            flex: 6,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isMobile = screenWidth < 700;

    final String query = _searchController.text.toLowerCase();
    final List<Map<String, dynamic>> filteredSections = _sections.where((item) {
      return (item['name'] as String).toLowerCase().contains(query) ||
          (item['class'] as String).toLowerCase().contains(query) ||
          (item['teacher'] as String).toLowerCase().contains(query) ||
          (item['room'] as String).toLowerCase().contains(query);
    }).toList();

    // Unique rooms
    final int roomsUsed = _sections.map((s) => s['room']).toSet().length;

    // Average capacity
    final double avgCapacity = _sections.isEmpty 
        ? 0 
        : _sections.map((s) => s['strength'] as int).reduce((a, b) => a + b) / _sections.length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue.withOpacity(0.85), AppColors.primaryBlue.withOpacity(0.55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.layers_outlined, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Section Management Panel',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Divide grade classes into operational sections, assign rooms and class mentors.',
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isMobile ? 3.5 : 2.8,
            children: [
              GestureDetector(
                onTap: _showSectionsSummaryDialog,
                child: _buildStatsCard('Total Active Sections', '${_sections.length}', Icons.layers, Colors.blue),
              ),
              GestureDetector(
                onTap: _showClassroomsDetailDialog,
                child: _buildStatsCard('Classrooms Used', '$roomsUsed Rooms', Icons.door_sliding, Colors.green),
              ),
              GestureDetector(
                onTap: _showStrengthDetailDialog,
                child: _buildStatsCard('Avg Section Strength', '${avgCapacity.toStringAsFixed(1)} Students', Icons.group, Colors.orange),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Records table
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
            ),
            padding: EdgeInsets.all(isMobile ? 14 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Operational Sections',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.grey),
                      tooltip: 'View Deleted History',
                      onPressed: _showTrashArchiveDialog,
                    ),
                    if (isMobile) const SizedBox(height: 12),
                    if (!isMobile) const Spacer(),
                    SizedBox(
                      width: isMobile ? double.infinity : 200,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search sections...',
                          prefixIcon: const Icon(Icons.search, size: 18),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onPressed: () => _showAddEditDialog(),
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('Add Section', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredSections.length,
                  separatorBuilder: (c, i) => const Divider(height: 16),
                  itemBuilder: (context, idx) {
                    final item = filteredSections[idx];
                    final originalIndex = _sections.indexOf(item);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () => _showViewDetailsDialog(item),
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                        child: const Icon(Icons.layers, color: AppColors.primaryBlue, size: 18),
                      ),
                      title: Text(
                        '${item['class']} - ${item['name']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          'MENTOR: ${item['teacher']} | ROOM: ${item['room']} | CAPACITY: ${item['strength']} Students',
                          style: TextStyle(color: isDark ? Colors.grey : Colors.grey.shade600, fontSize: 11),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: item['status'] == 'Active'
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item['status'],
                              style: TextStyle(
                                color: item['status'] == 'Active' ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, size: 16, color: Colors.blue),
                            onPressed: () => _showViewDetailsDialog(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.green),
                            onPressed: () => _showAddEditDialog(existingSection: item, index: originalIndex),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _deletedSections.add(item);
                                _sections.removeAt(originalIndex);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Section moved to Delete History.'),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    textColor: Colors.yellow,
                                    onPressed: () {
                                      setState(() {
                                        _sections.insert(originalIndex, item);
                                        _deletedSections.remove(item);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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

  Widget _buildStatsCard(String title, String count, IconData icon, Color color) {
    final bool isDark = widget.isDark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? null : Colors.white,
        gradient: isDark
            ? LinearGradient(
                colors: [color.withOpacity(0.18), color.withOpacity(0.03)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? color.withOpacity(0.25) : Colors.grey.shade100,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                count,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
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

  void _pickImage(Map<String, dynamic> row) {
    try {
      final input = html.FileUploadInputElement()..accept = 'image/*';
      input.click();
      input.onChange.listen((event) {
        final files = input.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((e) {
            final result = reader.result;
            if (result is Uint8List) {
              setState(() {
                row['imageBytes'] = result;
                row['imageName'] = file.name;
                row['mimeType'] = file.type.isNotEmpty ? file.type : 'image/jpeg';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Attached image: ${file.name}'), backgroundColor: Colors.green),
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Web homework picker error: $e");
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
class AttendanceManagementPanel extends StatefulWidget {
  final bool isDark;

  const AttendanceManagementPanel({super.key, required this.isDark});

  @override
  State<AttendanceManagementPanel> createState() => _AttendanceManagementPanelState();
}

class _AttendanceManagementPanelState extends State<AttendanceManagementPanel> {
  DateTime _selectedDate = DateTime.now();
  String _selectedClass = 'All Classes';

  int _qrSecondsRemaining = 86400;
  Timer? _qrTimer;
  String _qrClassScope = 'All Classes';
  String? _customQrUrl;
  String _currentQrToken = 'ATTENDANCE_TOKEN_All_Classes';
  bool _isAutoGenerated = true;

  @override
  void initState() {
    super.initState();
    _startQrTimer();
  }

  void _startQrTimer() {
    _qrTimer?.cancel();
    _qrTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_qrSecondsRemaining > 0) {
            _qrSecondsRemaining--;
          } else {
            _qrSecondsRemaining = 86400; // Reset to 24h
            _currentQrToken = 'ATTENDANCE_TOKEN_${_qrClassScope.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _qrTimer?.cancel();
    super.dispose();
  }

  void _syncQrToApp() {
    final acadProvider = Provider.of<AcademicProvider>(context, listen: false);
    acadProvider.updateQrConfig(
      token: _currentQrToken,
      classScope: _qrClassScope,
      customUrl: _customQrUrl,
      secondsRemaining: _qrSecondsRemaining,
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.sync, color: Colors.white),
            SizedBox(width: 8),
            Text('Sync Successful! QR Config updated in mobile screens! 📱🟢'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatSeconds(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
  }

  // Map of studentId -> AttendanceStatus ('Present', 'Absent', 'Late', 'Leave')
  final Map<String, String> _attendanceMap = {};

  final List<String> _classesList = [
    'All Classes', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: widget.isDark ? ThemeData.dark() : ThemeData.light(),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _simulateExportCSV(List<UserProfile> students) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.download_done, color: Colors.greenAccent),
            const SizedBox(width: 8),
            Text('Downloaded attendance report for ${students.length} students! 📄'),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _simulateSaveAttendance() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.save, color: Colors.white),
            SizedBox(width: 8),
            Text('Attendance register successfully saved & synced! 💾'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _markAll(List<UserProfile> students, String status) {
    setState(() {
      for (var s in students) {
        _attendanceMap[s.uid] = status;
      }
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All matching student rows set to $status! ⚡'),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  Widget _buildStatusToggle(String studentId, String status, Color color, IconData icon, String label, String studentName) {
    final bool isActive = _attendanceMap[studentId] == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _attendanceMap[studentId] = status;
        });
        if (status == 'Absent') {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.notifications_active, color: Colors.yellow),
                  const SizedBox(width: 8),
                  Text('SMS & Push Alert triggered for $studentName\'s Parent! 📱'),
                ],
              ),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? color : Colors.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? color : Colors.grey, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? color : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, String count, IconData icon, Color color) {
    final bool isDark = widget.isDark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? null : Colors.white,
        gradient: isDark
            ? LinearGradient(
                colors: [color.withOpacity(0.18), color.withOpacity(0.03)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? color.withOpacity(0.25) : Colors.grey.shade100,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                count,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;
    final webVm = Provider.of<WebPanelViewModel>(context);
    final students = webVm.studentsList;

    // Initialize attendance status
    for (var student in students) {
      if (!_attendanceMap.containsKey(student.uid)) {
        _attendanceMap[student.uid] = 'Present';
      }
    }

    // Filter by selected class
    final List<UserProfile> filteredStudents = students.where((student) {
      if (_selectedClass == 'All Classes') return true;
      return student.userClass.trim().toLowerCase() == _selectedClass.trim().toLowerCase();
    }).toList();

    // Statistics calculations
    final int total = filteredStudents.length;
    int present = 0;
    int absent = 0;
    int lateCount = 0;
    int leaveCount = 0;

    for (var student in filteredStudents) {
      final status = _attendanceMap[student.uid] ?? 'Present';
      if (status == 'Present') present++;
      else if (status == 'Absent') absent++;
      else if (status == 'Late') lateCount++;
      else if (status == 'Leave') leaveCount++;
    }

    final double attendanceRate = total == 0 ? 0.0 : ((present + lateCount) / total) * 100;
    final String dateString = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isMobile = screenWidth < 700;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner card with Filters
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue.withOpacity(0.85), AppColors.primaryBlue.withOpacity(0.55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: isMobile ? 0 : 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily Attendance Panel',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mark student records, view rates, and automatically trigger parent alerts.',
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                if (isMobile) const SizedBox(height: 16),
                Row(
                  children: [
                    // Date selector button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white24,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today, size: 14),
                      label: Text(dateString, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    // Class selector dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedClass,
                          dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 12),
                          iconEnabledColor: Colors.white,
                          items: _classesList.map((c) {
                            return DropdownMenuItem<String>(
                              value: c,
                              child: Text(c, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedClass = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats grid row
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isMobile ? 2.5 : 2.8,
            children: [
              _buildStatsCard('Attendance Rate', '${attendanceRate.toStringAsFixed(1)}%', Icons.analytics, Colors.blue),
              _buildStatsCard('Total Students', '$total Students', Icons.people, Colors.green),
              _buildStatsCard('Absent Alert Count', '$absent Absent', Icons.warning, Colors.red),
              _buildStatsCard('On Leaves', '$leaveCount Leave', Icons.medical_services, Colors.orange),
            ],
          ),

          const SizedBox(height: 20),

          // QR Console Container
          Container(
            decoration: BoxDecoration(
              color: isDark ? null : Colors.white,
              gradient: isDark
                  ? LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.12),
                        Colors.blue.withOpacity(0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.blue.withOpacity(0.25) : Colors.grey.shade100,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.qr_code_2, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Interactive QR Attendance Console',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left QR Code Preview
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(
                              child: _customQrUrl != null
                                  ? Image.network(_customQrUrl!, fit: BoxFit.contain)
                                  : Image.network(
                                      'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=https://agarwalknowledgehub.vercel.app/?action=qr_attendance%26token=$_currentQrToken%26class=${Uri.encodeComponent(_qrClassScope)}',
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(child: CircularProgressIndicator());
                                      },
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isAutoGenerated ? 'Auto-Generated QR Code' : 'Custom Uploaded QR Code',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Right settings
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('QR Attendance Scope', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.withOpacity(0.4)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _qrClassScope,
                                dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                                isExpanded: true,
                                style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black87),
                                items: _classesList.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _qrClassScope = val;
                                      _currentQrToken = 'ATTENDANCE_TOKEN_${val.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
                                      _isAutoGenerated = true;
                                      _customQrUrl = null;
                                    });
                                    _syncQrToApp();
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('Custom QR Code URL (Optional)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onSubmitted: (val) {
                                    if (val.trim().isNotEmpty) {
                                      setState(() {
                                        _customQrUrl = val.trim();
                                        _isAutoGenerated = false;
                                      });
                                      _syncQrToApp();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Paste custom QR image URL',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _customQrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&color=050e2e&data=https://agarwalknowledgehub.vercel.app';
                                    _isAutoGenerated = false;
                                  });
                                  _syncQrToApp();
                                },
                                child: const Text('Add Custom', style: TextStyle(fontSize: 11)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rotates in: ${_formatSeconds(_qrSecondsRemaining)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 12),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: _syncQrToApp,
                                icon: const Icon(Icons.sync, size: 12),
                                label: const Text('Sync QR to Mobile App', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Actions and Attendance Grid
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
            ),
            padding: EdgeInsets.all(isMobile ? 14 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bulk action actions row
                Flex(
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: [
                    const Text('Student Roster Grid', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    if (isMobile) const SizedBox(height: 12),
                    if (!isMobile) const Spacer(),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _markAll(filteredStudents, 'Present'),
                          icon: const Icon(Icons.done_all, size: 14),
                          label: const Text('All Present', style: TextStyle(fontSize: 11)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green),
                            foregroundColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () => _markAll(filteredStudents, 'Absent'),
                          icon: const Icon(Icons.close, size: 14),
                          label: const Text('All Absent', style: TextStyle(fontSize: 11)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            foregroundColor: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _simulateExportCSV(filteredStudents),
                          icon: const Icon(Icons.download, size: 14),
                          label: const Text('Export Excel', style: TextStyle(fontSize: 11)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Attendance Roster List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredStudents.length,
                  separatorBuilder: (c, i) => const Divider(height: 16),
                  itemBuilder: (context, idx) {
                    final student = filteredStudents[idx];
                    return Flex(
                      direction: isMobile ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: isMobile ? 0 : 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 2),
                              Text(student.userClass, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ),
                        if (isMobile) const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _buildStatusToggle(student.uid, 'Present', Colors.green, Icons.check_circle_outline, 'Present', student.name),
                            _buildStatusToggle(student.uid, 'Absent', Colors.red, Icons.cancel_outlined, 'Absent', student.name),
                            _buildStatusToggle(student.uid, 'Late', Colors.orange, Icons.watch_later_outlined, 'Late', student.name),
                            _buildStatusToggle(student.uid, 'Leave', Colors.blue, Icons.medical_services_outlined, 'Leave', student.name),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Save button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _simulateSaveAttendance,
                    icon: const Icon(Icons.cloud_upload_outlined),
                    label: const Text('Save Daily Attendance', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
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
  int _activeSectionIndex = 0;
  bool _initialized = false;

  // 1. General Settings Controllers
  late TextEditingController _appNameCtrl;
  late TextEditingController _instNameCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _websiteCtrl;
  late TextEditingController _aboutCtrl;
  late TextEditingController _copyrightCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _timeZoneCtrl;
  late TextEditingController _currencyCtrl;
  late TextEditingController _dateFormatCtrl;
  late TextEditingController _timeFormatCtrl;
  String _defaultLanguage = 'English';

  // 2. Appearance & Branding Controllers
  late TextEditingController _primaryColorCtrl;
  late TextEditingController _secondaryColorCtrl;
  late TextEditingController _accentColorCtrl;
  late TextEditingController _loginBrandingCtrl;
  late TextEditingController _borderRadiusCtrl;
  String _themeMode = 'system'; // 'light' | 'dark' | 'system'
  String _cardStyle = 'Glassmorphism'; // '3D' | 'Flat' | 'Glassmorphism'
  String _uiDensity = 'Comfortable'; // 'Comfortable' | 'Compact'
  bool _animationsEnabled = true;
  bool _smoothTransitions = true;

  // 3. Security Settings Controllers
  late TextEditingController _sessionTimeoutCtrl;
  late TextEditingController _maxAttemptsCtrl;
  late TextEditingController _lockoutCtrl;
  bool _twoFactorAuthEnabled = false;
  bool _suspiciousLoginDetection = true;
  String _passwordPolicy = 'Medium'; // 'Simple' | 'Medium' | 'Strong'
  bool _reAuthRequired = true;

  // 4. Authentication Settings Controllers
  late TextEditingController _otpExpiryCtrl;
  late TextEditingController _resendOtpCtrl;
  bool _mobileLoginEnabled = true;
  bool _realOtpEnabled = false;
  bool _emailLoginEnabled = true;
  bool _passwordLoginEnabled = true;
  bool _googleLoginEnabled = true;
  bool _guestLoginEnabled = false;
  bool _rememberLogin = true;
  bool _autoLogin = true;
  bool _forgotPasswordEnabled = true;

  // 5. Notification Settings Controllers
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _smsNotificationsEnabled = false;
  bool _whatsAppNotificationsEnabled = false;
  String _notificationSound = 'Default Chime';
  bool _systemAlertsEnabled = true;
  bool _maintenanceAlertsEnabled = true;
  bool _securityAlertsEnabled = true;

  // 6. Language & Localization
  String _numberFormat = '1,23,456.78 (Indian)';

  // 7. AI Configuration Controllers
  late TextEditingController _freeLimitCtrl;
  late TextEditingController _premiumLimitCtrl;
  late TextEditingController _voiceSpeedCtrl;
  late TextEditingController _voiceVolumeCtrl;
  late TextEditingController _ttsTextCtrl;
  bool _aiFeaturesEnabled = true;
  bool _aiTutorEnabled = true;
  bool _aiDoubtSolverEnabled = true;
  bool _imageQuestionEnabled = true;
  bool _voiceQuestionEnabled = true;
  bool _aiQuizGeneratorEnabled = true;
  bool _aiContentGeneratorEnabled = true;
  bool _aiVoiceEnabled = true;
  String _voiceGender = 'Female';
  bool _voiceAutoPlay = false;

  // 8. Monetization Controllers
  late TextEditingController _freeTrialDaysCtrl;
  bool _monetizationEnabled = false;
  bool _premiumSystemEnabled = false;
  bool _adsEnabled = false;
  bool _bannerAdsEnabled = false;
  bool _rewardedAdsEnabled = false;
  bool _couponSystemEnabled = false;
  bool _referralSystemEnabled = false;
  String _paymentGatewayStatus = 'Sandbox'; // 'Active' | 'Sandbox' | 'Inactive'

  // 9. Maintenance & Updates Controllers
  late TextEditingController _maintenanceMsgCtrl;
  late TextEditingController _scheduledTimeCtrl;
  late TextEditingController _currentVersionCtrl;
  late TextEditingController _latestVersionCtrl;
  late TextEditingController _minVersionCtrl;
  late TextEditingController _updateMsgCtrl;
  late TextEditingController _playStoreCtrl;
  late TextEditingController _appStoreCtrl;
  late TextEditingController _websiteLinkCtrl;
  late TextEditingController _privacyCtrl;
  late TextEditingController _termsCtrl;
  bool _maintenanceModeEnabled = false;
  bool _forceUpdateEnabled = false;

  // 10. Backup & Data Controllers
  late TextEditingController _retentionCtrl;
  bool _autoBackupEnabled = true;
  String _backupSchedule = 'Daily';

  // Audit Logs Search & Filters
  String _logSearchQuery = '';
  String _logFilterAction = 'All';
  String _logFilterRole = 'All';
  int _logCurrentPage = 1;
  static const int _logPageSize = 8;

  // Local File Previews (picked bytes)
  Uint8List? _logoBytes;
  String? _logoName;
  Uint8List? _iconBytes;
  String? _iconName;
  Uint8List? _faviconBytes;
  String? _faviconName;
  Uint8List? _loginBgBytes;
  String? _loginBgName;
  Uint8List? _loginLogoBytes;
  String? _loginLogoName;

  bool _isTtsSpeaking = false;
  bool _isBackupInProgress = false;

  final List<Map<String, dynamic>> _tabs = [
    {'title': 'General Settings', 'icon': Icons.info_outline},
    {'title': 'Appearance & Branding', 'icon': Icons.palette_outlined},
    {'title': 'Security Settings', 'icon': Icons.security_outlined, 'adminOnly': true},
    {'title': 'Authentication Config', 'icon': Icons.vpn_key_outlined},
    {'title': 'Global Notifications', 'icon': Icons.notifications_none_outlined},
    {'title': 'Language & Localization', 'icon': Icons.translate_outlined},
    {'title': 'AI Configuration', 'icon': Icons.smart_toy_outlined},
    {'title': 'Monetization System', 'icon': Icons.monetization_on_outlined},
    {'title': 'Maintenance & Updates', 'icon': Icons.system_update_alt_outlined},
    {'title': 'Backup & Data Registry', 'icon': Icons.storage_outlined, 'adminOnly': true},
    {'title': 'Audit Logs', 'icon': Icons.receipt_long_outlined},
  ];

  void _initFields(SystemSettings settings) {
    if (_initialized) return;
    _initialized = true;

    _appNameCtrl = TextEditingController(text: settings.appName);
    _instNameCtrl = TextEditingController(text: settings.instituteName);
    _addressCtrl = TextEditingController(text: settings.address);
    _phoneCtrl = TextEditingController(text: settings.phone);
    _emailCtrl = TextEditingController(text: settings.email);
    _websiteCtrl = TextEditingController(text: settings.website);
    _aboutCtrl = TextEditingController(text: settings.aboutApp);
    _copyrightCtrl = TextEditingController(text: settings.copyrightText);
    _countryCtrl = TextEditingController(text: settings.country);
    _timeZoneCtrl = TextEditingController(text: settings.timeZone);
    _currencyCtrl = TextEditingController(text: settings.currency);
    _dateFormatCtrl = TextEditingController(text: settings.dateFormat);
    _timeFormatCtrl = TextEditingController(text: settings.timeFormat);
    _defaultLanguage = settings.defaultLanguage;

    _primaryColorCtrl = TextEditingController(text: settings.primaryColorHex);
    _secondaryColorCtrl = TextEditingController(text: settings.secondaryColorHex);
    _accentColorCtrl = TextEditingController(text: settings.accentColorHex);
    _loginBrandingCtrl = TextEditingController(text: settings.loginBrandingTitle);
    _borderRadiusCtrl = TextEditingController(text: settings.borderRadius.toString());
    _themeMode = settings.themeMode;
    _cardStyle = settings.cardStyle;
    _uiDensity = settings.uiDensity;
    _animationsEnabled = settings.animationsEnabled;
    _smoothTransitions = settings.smoothTransitions;

    _sessionTimeoutCtrl = TextEditingController(text: settings.sessionTimeoutMinutes.toString());
    _maxAttemptsCtrl = TextEditingController(text: settings.maxLoginAttempts.toString());
    _lockoutCtrl = TextEditingController(text: settings.accountLockoutMinutes.toString());
    _twoFactorAuthEnabled = settings.twoFactorAuthEnabled;
    _suspiciousLoginDetection = settings.suspiciousLoginDetection;
    _passwordPolicy = settings.passwordPolicy;
    _reAuthRequired = settings.reAuthRequired;

    _otpExpiryCtrl = TextEditingController(text: settings.otpExpirySeconds.toString());
    _resendOtpCtrl = TextEditingController(text: settings.resendOtpSeconds.toString());
    _mobileLoginEnabled = settings.mobileLoginEnabled;
    _realOtpEnabled = settings.realOtpEnabled;
    _emailLoginEnabled = settings.emailLoginEnabled;
    _passwordLoginEnabled = settings.passwordLoginEnabled;
    _googleLoginEnabled = settings.googleLoginEnabled;
    _guestLoginEnabled = settings.guestLoginEnabled;
    _rememberLogin = settings.rememberLogin;
    _autoLogin = settings.autoLogin;
    _forgotPasswordEnabled = settings.forgotPasswordEnabled;

    _pushNotificationsEnabled = settings.pushNotificationsEnabled;
    _emailNotificationsEnabled = settings.emailNotificationsEnabled;
    _smsNotificationsEnabled = settings.smsNotificationsEnabled;
    _whatsAppNotificationsEnabled = settings.whatsAppNotificationsEnabled;
    _notificationSound = settings.notificationSound;
    _systemAlertsEnabled = settings.systemAlertsEnabled;
    _maintenanceAlertsEnabled = settings.maintenanceAlertsEnabled;
    _securityAlertsEnabled = settings.securityAlertsEnabled;

    _numberFormat = settings.numberFormat;

    _freeLimitCtrl = TextEditingController(text: settings.freeUserDailyLimit.toString());
    _premiumLimitCtrl = TextEditingController(text: settings.premiumUserDailyLimit.toString());
    _voiceSpeedCtrl = TextEditingController(text: settings.speechSpeed.toString());
    _voiceVolumeCtrl = TextEditingController(text: settings.voiceVolume.toString());
    _ttsTextCtrl = TextEditingController(text: "Welcome to Agarwal Knowledge Hub! Speak clearly to ask your doubts.");
    _aiFeaturesEnabled = settings.aiFeaturesEnabled;
    _aiTutorEnabled = settings.aiTutorEnabled;
    _aiDoubtSolverEnabled = settings.aiDoubtSolverEnabled;
    _imageQuestionEnabled = settings.imageQuestionEnabled;
    _voiceQuestionEnabled = settings.voiceQuestionEnabled;
    _aiQuizGeneratorEnabled = settings.aiQuizGeneratorEnabled;
    _aiContentGeneratorEnabled = settings.aiContentGeneratorEnabled;
    _aiVoiceEnabled = settings.aiVoiceEnabled;
    _voiceGender = settings.voiceGender;
    _voiceAutoPlay = settings.voiceAutoPlay;

    _freeTrialDaysCtrl = TextEditingController(text: settings.freeTrialDays.toString());
    _monetizationEnabled = settings.monetizationEnabled;
    _premiumSystemEnabled = settings.premiumSystemEnabled;
    _adsEnabled = settings.adsEnabled;
    _bannerAdsEnabled = settings.bannerAdsEnabled;
    _rewardedAdsEnabled = settings.rewardedAdsEnabled;
    _couponSystemEnabled = settings.couponSystemEnabled;
    _referralSystemEnabled = settings.referralSystemEnabled;
    _paymentGatewayStatus = settings.paymentGatewayStatus;

    _maintenanceMsgCtrl = TextEditingController(text: settings.maintenanceMessage);
    _scheduledTimeCtrl = TextEditingController(text: settings.scheduledMaintenanceTime);
    _currentVersionCtrl = TextEditingController(text: settings.currentAppVersion);
    _latestVersionCtrl = TextEditingController(text: settings.latestAppVersion);
    _minVersionCtrl = TextEditingController(text: settings.minSupportedVersion);
    _updateMsgCtrl = TextEditingController(text: settings.updateMessage);
    _playStoreCtrl = TextEditingController(text: settings.playStoreLink);
    _appStoreCtrl = TextEditingController(text: settings.appStoreLink);
    _websiteLinkCtrl = TextEditingController(text: settings.websiteLink);
    _privacyCtrl = TextEditingController(text: settings.privacyPolicyLink);
    _termsCtrl = TextEditingController(text: settings.termsConditionsLink);
    _maintenanceModeEnabled = settings.maintenanceModeEnabled;
    _forceUpdateEnabled = settings.forceUpdateEnabled;

    _retentionCtrl = TextEditingController(text: settings.dataRetentionDays.toString());
    _autoBackupEnabled = settings.autoBackupEnabled;
    _backupSchedule = settings.backupSchedule;
  }

  void _pickGeneralImage(String type) {
    try {
      final input = html.FileUploadInputElement()..accept = 'image/*';
      input.click();
      input.onChange.listen((event) {
        final files = input.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((e) {
            final result = reader.result;
            if (result is Uint8List) {
              setState(() {
                if (type == 'logo') {
                  _logoBytes = result;
                  _logoName = file.name;
                } else if (type == 'icon') {
                  _iconBytes = result;
                  _iconName = file.name;
                } else if (type == 'favicon') {
                  _faviconBytes = result;
                  _faviconName = file.name;
                } else if (type == 'loginBg') {
                  _loginBgBytes = result;
                  _loginBgName = file.name;
                } else if (type == 'loginLogo') {
                  _loginLogoBytes = result;
                  _loginLogoName = file.name;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Picked $type image: ${file.name}'), backgroundColor: Colors.green),
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Web general image picker error: $e");
    }
  }

  void _removeGeneralImage(String type) {
    setState(() {
      if (type == 'logo') {
        _logoBytes = null;
        _logoName = null;
      } else if (type == 'icon') {
        _iconBytes = null;
        _iconName = null;
      } else if (type == 'favicon') {
        _faviconBytes = null;
        _faviconName = null;
      } else if (type == 'loginBg') {
        _loginBgBytes = null;
        _loginBgName = null;
      } else if (type == 'loginLogo') {
        _loginLogoBytes = null;
        _loginLogoName = null;
      }
    });
  }

  void _resetUnsaved(SystemSettings settings) {
    setState(() {
      _initialized = false;
      _logoBytes = null;
      _iconBytes = null;
      _faviconBytes = null;
      _loginBgBytes = null;
      _loginLogoBytes = null;
      _initFields(settings);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All unsaved modifications reset! 🔄'), backgroundColor: AppColors.secondaryOrange),
    );
  }

  Future<void> _saveAllChanges(SystemSettings current, SettingsViewModel settingsVm, UserProfile user, EnterpriseProvider entProvider) async {
    if (_appNameCtrl.text.trim().isEmpty || _instNameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Application & Institute names are required.'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      String logoUrl = current.logoUrl;
      String iconUrl = current.iconUrl;
      String faviconUrl = current.faviconUrl;
      String loginBgUrl = current.loginBackgroundUrl;
      String loginLogoUrl = current.loginPageLogoUrl;

      if (_logoBytes != null) logoUrl = 'https://firebasestorage.googleapis.com/v0/b/agarwal-knowledge-hub/o/logo.png?alt=media';
      if (_iconBytes != null) iconUrl = 'https://firebasestorage.googleapis.com/v0/b/agarwal-knowledge-hub/o/icon.png?alt=media';
      if (_faviconBytes != null) faviconUrl = 'https://firebasestorage.googleapis.com/v0/b/agarwal-knowledge-hub/o/favicon.png?alt=media';
      if (_loginBgBytes != null) loginBgUrl = 'https://firebasestorage.googleapis.com/v0/b/agarwal-knowledge-hub/o/login_bg.png?alt=media';
      if (_loginLogoBytes != null) loginLogoUrl = 'https://firebasestorage.googleapis.com/v0/b/agarwal-knowledge-hub/o/login_logo.png?alt=media';

      final updated = current.copyWith(
        appName: _appNameCtrl.text.trim(),
        instituteName: _instNameCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        website: _websiteCtrl.text.trim(),
        aboutApp: _aboutCtrl.text.trim(),
        copyrightText: _copyrightCtrl.text.trim(),
        country: _countryCtrl.text.trim(),
        timeZone: _timeZoneCtrl.text.trim(),
        currency: _currencyCtrl.text.trim(),
        dateFormat: _dateFormatCtrl.text.trim(),
        timeFormat: _timeFormatCtrl.text.trim(),
        defaultLanguage: _defaultLanguage,
        logoUrl: logoUrl,
        iconUrl: iconUrl,
        faviconUrl: faviconUrl,

        themeMode: _themeMode,
        primaryColorHex: _primaryColorCtrl.text.trim(),
        secondaryColorHex: _secondaryColorCtrl.text.trim(),
        accentColorHex: _accentColorCtrl.text.trim(),
        loginBrandingTitle: _loginBrandingCtrl.text.trim(),
        loginBackgroundUrl: loginBgUrl,
        loginPageLogoUrl: loginLogoUrl,
        animationsEnabled: _animationsEnabled,
        smoothTransitions: _smoothTransitions,
        uiDensity: _uiDensity,
        borderRadius: double.tryParse(_borderRadiusCtrl.text) ?? 16.0,
        cardStyle: _cardStyle,

        twoFactorAuthEnabled: _twoFactorAuthEnabled,
        sessionTimeoutMinutes: int.tryParse(_sessionTimeoutCtrl.text) ?? 30,
        maxLoginAttempts: int.tryParse(_maxAttemptsCtrl.text) ?? 5,
        accountLockoutMinutes: int.tryParse(_lockoutCtrl.text) ?? 15,
        suspiciousLoginDetection: _suspiciousLoginDetection,
        passwordPolicy: _passwordPolicy,
        reAuthRequired: _reAuthRequired,

        mobileLoginEnabled: _mobileLoginEnabled,
        realOtpEnabled: _realOtpEnabled,
        emailLoginEnabled: _emailLoginEnabled,
        passwordLoginEnabled: _passwordLoginEnabled,
        googleLoginEnabled: _googleLoginEnabled,
        guestLoginEnabled: _guestLoginEnabled,
        rememberLogin: _rememberLogin,
        autoLogin: _autoLogin,
        forgotPasswordEnabled: _forgotPasswordEnabled,
        otpExpirySeconds: int.tryParse(_otpExpiryCtrl.text) ?? 60,
        resendOtpSeconds: int.tryParse(_resendOtpCtrl.text) ?? 30,

        pushNotificationsEnabled: _pushNotificationsEnabled,
        emailNotificationsEnabled: _emailNotificationsEnabled,
        smsNotificationsEnabled: _smsNotificationsEnabled,
        whatsAppNotificationsEnabled: _whatsAppNotificationsEnabled,
        notificationSound: _notificationSound,
        systemAlertsEnabled: _systemAlertsEnabled,
        maintenanceAlertsEnabled: _maintenanceAlertsEnabled,
        securityAlertsEnabled: _securityAlertsEnabled,

        numberFormat: _numberFormat,

        aiFeaturesEnabled: _aiFeaturesEnabled,
        aiTutorEnabled: _aiTutorEnabled,
        aiDoubtSolverEnabled: _aiDoubtSolverEnabled,
        imageQuestionEnabled: _imageQuestionEnabled,
        voiceQuestionEnabled: _voiceQuestionEnabled,
        aiQuizGeneratorEnabled: _aiQuizGeneratorEnabled,
        aiContentGeneratorEnabled: _aiContentGeneratorEnabled,
        freeUserDailyLimit: int.tryParse(_freeLimitCtrl.text) ?? 5,
        premiumUserDailyLimit: int.tryParse(_premiumLimitCtrl.text) ?? 100,
        aiVoiceEnabled: _aiVoiceEnabled,
        voiceGender: _voiceGender,
        voiceAutoPlay: _voiceAutoPlay,
        speechSpeed: double.tryParse(_voiceSpeedCtrl.text) ?? 1.0,
        voiceVolume: double.tryParse(_voiceVolumeCtrl.text) ?? 0.8,

        monetizationEnabled: _monetizationEnabled,
        premiumSystemEnabled: _premiumSystemEnabled,
        freeTrialDays: int.tryParse(_freeTrialDaysCtrl.text) ?? 7,
        adsEnabled: _adsEnabled,
        bannerAdsEnabled: _bannerAdsEnabled,
        rewardedAdsEnabled: _rewardedAdsEnabled,
        couponSystemEnabled: _couponSystemEnabled,
        referralSystemEnabled: _referralSystemEnabled,
        paymentGatewayStatus: _paymentGatewayStatus,

        maintenanceModeEnabled: _maintenanceModeEnabled,
        maintenanceMessage: _maintenanceMsgCtrl.text.trim(),
        scheduledMaintenanceTime: _scheduledTimeCtrl.text.trim(),
        currentAppVersion: _currentVersionCtrl.text.trim(),
        latestAppVersion: _latestVersionCtrl.text.trim(),
        minSupportedVersion: _minVersionCtrl.text.trim(),
        forceUpdateEnabled: _forceUpdateEnabled,
        updateMessage: _updateMsgCtrl.text.trim(),
        playStoreLink: _playStoreCtrl.text.trim(),
        appStoreLink: _appStoreCtrl.text.trim(),
        websiteLink: _websiteLinkCtrl.text.trim(),
        privacyPolicyLink: _privacyCtrl.text.trim(),
        termsConditionsLink: _termsCtrl.text.trim(),

        autoBackupEnabled: _autoBackupEnabled,
        backupSchedule: _backupSchedule,
        dataRetentionDays: int.tryParse(_retentionCtrl.text) ?? 365,
      );

      await settingsVm.updateSettings(updated);
      entProvider.logAction(user.name, user.role, 'Settings', 'Updated global settings configuration.');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('System configuration settings saved successfully! 💾'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving settings: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _speakTTS(String text, String gender, double speed, double volume) {
    try {
      final synth = html.window.speechSynthesis;
      if (synth != null) {
        setState(() {
          _isTtsSpeaking = true;
        });
        synth.cancel();
        final utterance = html.SpeechSynthesisUtterance(text);
        utterance.rate = speed;
        utterance.volume = volume;

        final voices = synth.getVoices();
        if (voices.isNotEmpty) {
          final isFemale = gender == 'Female';
          final matched = voices.firstWhere(
            (v) {
              final name = (v.name ?? '').toLowerCase();
              return isFemale 
                  ? name.contains('female') || name.contains('zira') || name.contains('google uk english female')
                  : name.contains('male') || name.contains('david') || name.contains('google uk english male');
            },
            orElse: () => voices.first,
          );
          utterance.voice = matched;
        }

        Future.delayed(Duration(milliseconds: (text.length * 80).clamp(1500, 8000)), () {
          if (mounted) {
            setState(() {
              _isTtsSpeaking = false;
            });
          }
        });
        synth.speak(utterance);
      }
    } catch (e) {
      debugPrint("Web TTS failed: $e");
    }
  }

  void _stopTTS() {
    try {
      final synth = html.window.speechSynthesis;
      if (synth != null) {
        synth.cancel();
        setState(() {
          _isTtsSpeaking = false;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    if (_initialized) {
      _appNameCtrl.dispose();
      _instNameCtrl.dispose();
      _addressCtrl.dispose();
      _phoneCtrl.dispose();
      _emailCtrl.dispose();
      _websiteCtrl.dispose();
      _aboutCtrl.dispose();
      _copyrightCtrl.dispose();
      _countryCtrl.dispose();
      _timeZoneCtrl.dispose();
      _currencyCtrl.dispose();
      _dateFormatCtrl.dispose();
      _timeFormatCtrl.dispose();

      _primaryColorCtrl.dispose();
      _secondaryColorCtrl.dispose();
      _accentColorCtrl.dispose();
      _loginBrandingCtrl.dispose();
      _borderRadiusCtrl.dispose();

      _sessionTimeoutCtrl.dispose();
      _maxAttemptsCtrl.dispose();
      _lockoutCtrl.dispose();

      _otpExpiryCtrl.dispose();
      _resendOtpCtrl.dispose();

      _freeLimitCtrl.dispose();
      _premiumLimitCtrl.dispose();
      _voiceSpeedCtrl.dispose();
      _voiceVolumeCtrl.dispose();
      _ttsTextCtrl.dispose();

      _freeTrialDaysCtrl.dispose();

      _maintenanceMsgCtrl.dispose();
      _scheduledTimeCtrl.dispose();
      _currentVersionCtrl.dispose();
      _latestVersionCtrl.dispose();
      _minVersionCtrl.dispose();
      _updateMsgCtrl.dispose();
      _playStoreCtrl.dispose();
      _appStoreCtrl.dispose();
      _websiteLinkCtrl.dispose();
      _privacyCtrl.dispose();
      _termsCtrl.dispose();

      _retentionCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsVm = Provider.of<SettingsViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context);
    final entProvider = Provider.of<EnterpriseProvider>(context);

    final user = authVm.userProfile;
    if (user == null) {
      return const Center(child: Text('Not authenticated. Please login first.'));
    }

    final isSuperAdmin = user.role == AppStrings.roleSuperAdmin;
    final isAdmin = user.role == AppStrings.roleAdmin;

    // 1. Role-based settings accessibility enforcement
    if (!isSuperAdmin && !isAdmin) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: GlassContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.gpp_bad_outlined, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                const Text('Access Denied', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Global System Settings are restricted to Super Admins and School Admins. Your active role: ${user.role}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final settings = settingsVm.settings;
    _initFields(settings);

    if (settingsVm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBlue),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 850;
        
        final sidebar = Container(
          width: isMobile ? double.infinity : 280,
          decoration: BoxDecoration(
            color: widget.isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.02),
            border: Border(
              right: BorderSide(
                color: widget.isDark ? Colors.white12 : Colors.black12,
                width: isMobile ? 0 : 1,
              ),
              bottom: BorderSide(
                color: widget.isDark ? Colors.white12 : Colors.black12,
                width: isMobile ? 1 : 0,
              ),
            ),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: isMobile ? const NeverScrollableScrollPhysics() : const ScrollPhysics(),
            itemCount: _tabs.length,
            itemBuilder: (context, idx) {
              final tab = _tabs[idx];
              final bool isTabAdminOnly = tab['adminOnly'] == true;
              final bool isAccessible = !isTabAdminOnly || isSuperAdmin;
              final bool isActive = _activeSectionIndex == idx;

              return ListTile(
                selected: isActive,
                selectedColor: AppColors.primaryBlue,
                leading: Icon(
                  tab['icon'],
                  color: isAccessible 
                      ? (isActive ? AppColors.primaryBlue : (widget.isDark ? Colors.white70 : Colors.black87))
                      : Colors.grey,
                ),
                title: Text(
                  tab['title'],
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isAccessible ? null : Colors.grey,
                    decoration: isAccessible ? null : TextDecoration.lineThrough,
                  ),
                ),
                trailing: isTabAdminOnly 
                    ? const Icon(Icons.shield_outlined, size: 14, color: AppColors.secondaryOrange)
                    : null,
                onTap: () {
                  if (!isAccessible) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Access Blocked: Security & Backup settings are reserved for Super Admin only! 🛡️'),
                        backgroundColor: AppColors.secondaryOrange,
                      ),
                    );
                    return;
                  }
                  setState(() {
                    _activeSectionIndex = idx;
                  });
                },
              );
            },
          ),
        );

        final contentPane = Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tabs[_activeSectionIndex]['title'],
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      const Divider(height: 32),
                      
                      // Load Active Section Form
                      _buildActiveTabContent(_activeSectionIndex, settings, settingsVm, user, entProvider),
                    ],
                  ),
                ),
              ),
              if (_activeSectionIndex != 10)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: widget.isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.7),
                    border: Border(
                      top: BorderSide(
                        color: widget.isDark ? Colors.white12 : Colors.black12,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Reset Unsaved'),
                        onPressed: () => _resetUnsaved(settings),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text('Save System Changes', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () => _saveAllChanges(settings, settingsVm, user, entProvider),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );

        if (isMobile) {
          return SingleChildScrollView(
            child: Column(
              children: [
                sidebar,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                  child: _buildActiveTabContent(_activeSectionIndex, settings, settingsVm, user, entProvider),
                ),
                if (_activeSectionIndex != 10)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => _resetUnsaved(settings),
                          child: const Text('Reset'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => _saveAllChanges(settings, settingsVm, user, entProvider),
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sidebar,
            contentPane,
          ],
        );
      },
    );
  }

  Widget _buildActiveTabContent(int index, SystemSettings settings, SettingsViewModel settingsVm, UserProfile user, EnterpriseProvider entProvider) {
    switch (index) {
      case 0:
        return _buildGeneralTab(settings);
      case 1:
        return _buildAppearanceTab(settings);
      case 2:
        return _buildSecurityTab(settingsVm);
      case 3:
        return _buildAuthenticationTab(settings);
      case 4:
        return _buildNotificationsTab(settings);
      case 5:
        return _buildLocalizationTab(settings);
      case 6:
        return _buildAiTab(settings);
      case 7:
        return _buildMonetizationTab(settings);
      case 8:
        return _buildMaintenanceTab(settings);
      case 9:
        return _buildBackupTab(settings, settingsVm, user);
      case 10:
        return _buildAuditLogsTab(entProvider);
      default:
        return const SizedBox();
    }
  }

  // ==========================================
  // TAB BUILDERS
  // ==========================================

  Widget _buildGeneralTab(SystemSettings settings) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hub Identity & Metadata', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildImagePickBox('logo', 'App Logo', _logoBytes, settings.logoUrl),
              const SizedBox(width: 16),
              _buildImagePickBox('icon', 'App Icon', _iconBytes, settings.iconUrl),
              const SizedBox(width: 16),
              _buildImagePickBox('favicon', 'Favicon', _faviconBytes, settings.faviconUrl),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _appNameCtrl,
                  labelText: 'Application Name',
                  hintText: 'e.g. Agarwal Hub',
                  prefixIcon: Icons.apps,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _instNameCtrl,
                  labelText: 'Institute Name',
                  hintText: 'e.g. Agarwal Knowledge Hub',
                  prefixIcon: Icons.school,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _addressCtrl,
            labelText: 'Postal Address',
            hintText: 'e.g. Mithapur, Patna',
            prefixIcon: Icons.place,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _phoneCtrl,
                  labelText: 'Contact Phone',
                  hintText: 'e.g. +919876543210',
                  prefixIcon: Icons.phone,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _emailCtrl,
                  labelText: 'Contact Email',
                  hintText: 'e.g. info@hub.com',
                  prefixIcon: Icons.email,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _websiteCtrl,
            labelText: 'Official Website Link',
            hintText: 'e.g. https://hub.com',
            prefixIcon: Icons.link,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _aboutCtrl,
            labelText: 'About / Description',
            hintText: 'e.g. System metadata details...',
            prefixIcon: Icons.info,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _copyrightCtrl,
            labelText: 'Copyright Footer String',
            hintText: 'e.g. © 2026. All Rights Reserved.',
            prefixIcon: Icons.copyright,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickBox(String type, String label, Uint8List? bytes, String fallbackUrl) {
    final imageWidget = bytes != null 
        ? Image.memory(bytes, fit: BoxFit.cover)
        : (fallbackUrl.isNotEmpty ? Image.network(fallbackUrl, fit: BoxFit.cover) : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickGeneralImage(type),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: imageWidget ?? const Center(child: Icon(Icons.add_photo_alternate_outlined, color: Colors.grey)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => _pickGeneralImage(type),
              child: const Text('Pick', style: TextStyle(fontSize: 10)),
            ),
            if (bytes != null || fallbackUrl.isNotEmpty) ...[
              const SizedBox(width: 4),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  foregroundColor: Colors.red,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => _removeGeneralImage(type),
                child: const Text('Remove', style: TextStyle(fontSize: 10)),
              )
            ]
          ],
        )
      ],
    );
  }

  Widget _buildAppearanceTab(SystemSettings settings) {
    return Column(
      children: [
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Theme Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Active Theme Mode:  ', style: TextStyle(fontWeight: FontWeight.bold)),
                  ChoiceChip(
                    label: const Text('Light Mode'),
                    selected: _themeMode == 'light',
                    onSelected: (val) {
                      if (val) setState(() => _themeMode = 'light');
                    },
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Dark Mode'),
                    selected: _themeMode == 'dark',
                    onSelected: (val) {
                      if (val) setState(() => _themeMode = 'dark');
                    },
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('System Default'),
                    selected: _themeMode == 'system',
                    onSelected: (val) {
                      if (val) setState(() => _themeMode = 'system');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _primaryColorCtrl,
                      labelText: 'Primary Color Hex',
                      hintText: 'e.g. 1E3C72',
                      prefixIcon: Icons.color_lens,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _secondaryColorCtrl,
                      labelText: 'Secondary Color Hex',
                      hintText: 'e.g. FF5E36',
                      prefixIcon: Icons.color_lens_outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _accentColorCtrl,
                      labelText: 'Accent Color Hex',
                      hintText: 'e.g. FFC107',
                      prefixIcon: Icons.colorize,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildColorCircle('Blue ERP', '1E3C72', 'FF5E36'),
                  const SizedBox(width: 12),
                  _buildColorCircle('Purple Glow', '4A154B', 'FFC107'),
                  const SizedBox(width: 12),
                  _buildColorCircle('Teal Modern', '008080', 'FF7F50'),
                  const SizedBox(width: 12),
                  _buildColorCircle('Emerald Elite', '046A38', 'A3D9C9'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Branding Layout Aesthetics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Card Style Layout', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _cardStyle,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          items: ['Glassmorphism', '3D Inspired', 'Flat Minimalist'].map((s) {
                            return DropdownMenuItem(value: s, child: Text(s));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _cardStyle = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('UI Density', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _uiDensity,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          items: ['Comfortable', 'Compact'].map((s) {
                            return DropdownMenuItem(value: s, child: Text(s));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _uiDensity = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _borderRadiusCtrl,
                labelText: 'Component Border Radius (double)',
                hintText: 'e.g. 16.0',
                prefixIcon: Icons.rounded_corner,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Core Platform Micro-Animations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Enable smooth dashboard micro-animations.'),
                value: _animationsEnabled,
                onChanged: (val) => setState(() => _animationsEnabled = val),
              ),
              SwitchListTile(
                title: const Text('Smooth Page Transitions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Enable sliding and fading page navigation routes.'),
                value: _smoothTransitions,
                onChanged: (val) => setState(() => _smoothTransitions = val),
              ),
              const Divider(height: 32),
              const Text('Login Screen Customized Branding', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _loginBrandingCtrl,
                labelText: 'Login Welcome Header String',
                hintText: 'Welcome to Education ERP Hub',
                prefixIcon: Icons.login,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildImagePickBox('loginBg', 'Login BG Frame', _loginBgBytes, settings.loginBackgroundUrl),
                  const SizedBox(width: 24),
                  _buildImagePickBox('loginLogo', 'Login Screen Logo', _loginLogoBytes, settings.loginPageLogoUrl),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildColorCircle(String name, String pri, String sec) {
    return Tooltip(
      message: name,
      child: InkWell(
        onTap: () {
          setState(() {
            _primaryColorCtrl.text = pri;
            _secondaryColorCtrl.text = sec;
          });
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(int.parse('FF$pri', radix: 16)), Color(int.parse('FF$sec', radix: 16))],
            ),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityTab(SettingsViewModel settingsVm) {
    return Column(
      children: [
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Active Administrative Security', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Two-Factor Authentication (2FA)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Force Super Admin verification codes on sensitive operations.'),
                value: _twoFactorAuthEnabled,
                onChanged: (val) => setState(() => _twoFactorAuthEnabled = val),
              ),
              SwitchListTile(
                title: const Text('Suspicious Login Triggers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Track login IP addresses and trigger email security reports.'),
                value: _suspiciousLoginDetection,
                onChanged: (val) => setState(() => _suspiciousLoginDetection = val),
              ),
              SwitchListTile(
                title: const Text('Force Re-authentication', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Require credentials challenge before deleting users or restoring backups.'),
                value: _reAuthRequired,
                onChanged: (val) => setState(() => _reAuthRequired = val),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _sessionTimeoutCtrl,
                      labelText: 'Session Expiry (Minutes)',
                      hintText: '30',
                      prefixIcon: Icons.timer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _maxAttemptsCtrl,
                      labelText: 'Max Login Attempts',
                      hintText: '5',
                      prefixIcon: Icons.lock_open,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _lockoutCtrl,
                      labelText: 'Lockout Timeout (Minutes)',
                      hintText: '15',
                      prefixIcon: Icons.lock_outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Minimum Password Complexity Policy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: ['Simple', 'Medium', 'Strong'].map((policy) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(policy),
                      selected: _passwordPolicy == policy,
                      onSelected: (val) {
                        if (val) setState(() => _passwordPolicy = policy);
                      },
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Active System Sessions Registry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    onPressed: () {
                      settingsVm.terminateAllSessions();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Terminated all remote login sessions successfully! 🛡️')),
                      );
                    },
                    child: const Text('Force Logout All Devices'),
                  )
                ],
              ),
              const Divider(height: 32),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: settingsVm.activeSessions.length,
                itemBuilder: (context, index) {
                  final sess = settingsVm.activeSessions[index];
                  final bool isCurrent = sess['isCurrent'] == true;

                  return ListTile(
                    leading: Icon(
                      sess['device'].toString().contains('Phone') ? Icons.phone_android : Icons.computer,
                      color: isCurrent ? Colors.green : Colors.grey,
                    ),
                    title: Row(
                      children: [
                        Text(sess['device'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(width: 8),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                            child: const Text('Current', style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
                          )
                      ],
                    ),
                    subtitle: Text('OS: ${sess['os']} | Browser: ${sess['browser']} | Location: ${sess['location']} | Login: ${sess['loginTime']}'),
                    trailing: isCurrent 
                        ? null 
                        : IconButton(
                            icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                            onPressed: () {
                              settingsVm.terminateSession(sess['id']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Revoked login session for ${sess['device']}')),
                              );
                            },
                          ),
                  );
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Active Device Login Logs History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Divider(height: 32),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: settingsVm.loginHistory.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, idx) {
                  final h = settingsVm.loginHistory[idx];
                  final bool isSuccess = h['status'] == 'Success';
                  return ListTile(
                    leading: Icon(isSuccess ? Icons.verified_user : Icons.gpp_maybe, color: isSuccess ? Colors.green : Colors.red),
                    title: Text('${h['user']} (${h['role']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('IP: ${h['ip']} | Device: ${h['device']} | Time: ${h['timestamp']}'),
                    trailing: Text(h['status'], style: TextStyle(color: isSuccess ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildAuthenticationTab(SystemSettings settings) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Verification & Authentication Gateways', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Mobile OTP Verification Link', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Request mobile number OTP verification for new registrations.'),
            value: _mobileLoginEnabled,
            onChanged: (val) => setState(() => _mobileLoginEnabled = val),
          ),
          SwitchListTile(
            title: const Text('Real OTP Verification (SMS Gateway)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Verify mobile numbers via SMS gateway (OTP is simulated if off).'),
            value: _realOtpEnabled,
            onChanged: (val) => setState(() => _realOtpEnabled = val),
          ),
          SwitchListTile(
            title: const Text('Email & Password Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Allow sign-in using email address and security password.'),
            value: _emailLoginEnabled,
            onChanged: (val) => setState(() => _emailLoginEnabled = val),
          ),
          SwitchListTile(
            title: const Text('Google SSO OAuth Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Allow direct verification using Google Account credentials.'),
            value: _googleLoginEnabled,
            onChanged: (val) => setState(() => _googleLoginEnabled = val),
          ),
          SwitchListTile(
            title: const Text('Remember Login Session', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Automatically remember browser active authentication session.'),
            value: _rememberLogin,
            onChanged: (val) => setState(() => _rememberLogin = val),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _otpExpiryCtrl,
                  labelText: 'OTP Expiration Timeout (Seconds)',
                  hintText: '60',
                  prefixIcon: Icons.av_timer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _resendOtpCtrl,
                  labelText: 'Resend Trigger Timeout (Seconds)',
                  hintText: '30',
                  prefixIcon: Icons.repeat_one,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNotificationsTab(SystemSettings settings) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Global Notification Outbound Channels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Push Alert Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Send app alerts for homework, notice, or quiz schedules.'),
            value: _pushNotificationsEnabled,
            onChanged: (val) => setState(() => _pushNotificationsEnabled = val),
          ),
          SwitchListTile(
            title: const Text('Email Notice Alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Send emails to parents and students on urgent class notices.'),
            value: _emailNotificationsEnabled,
            onChanged: (val) => setState(() => _emailNotificationsEnabled = val),
          ),
          SwitchListTile(
            title: const Text('SMS Notice Alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Send urgent SMS text messages via the gateway.'),
            value: _smsNotificationsEnabled,
            onChanged: (val) => setState(() => _smsNotificationsEnabled = val),
          ),
          SwitchListTile(
            title: const Text('WhatsApp Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Send instant notifications to parent registered WhatsApp number.'),
            value: _whatsAppNotificationsEnabled,
            onChanged: (val) => setState(() => _whatsAppNotificationsEnabled = val),
          ),
          const Divider(height: 32),
          const Text('System Alerts Trigger', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('System Maintenance Warnings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Send alerts when system maintenance mode is scheduled.'),
            value: _maintenanceAlertsEnabled,
            onChanged: (val) => setState(() => _maintenanceAlertsEnabled = val),
          ),
          SwitchListTile(
            title: const Text('Security Alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Send alerts for failed login attempts or password resets.'),
            value: _securityAlertsEnabled,
            onChanged: (val) => setState(() => _securityAlertsEnabled = val),
          ),
          const SizedBox(height: 16),
          const Text('Default Alert Sound Effect', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _notificationSound,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: ['Default Chime', 'Vibrant Bell', 'Mute/Silent'].map((s) {
              return DropdownMenuItem(value: s, child: Text(s));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _notificationSound = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocalizationTab(SystemSettings settings) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Time, Language, and Format Localization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 24),
          const Text('Default Language Preference', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _defaultLanguage,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: ['English', 'Hindi'].map((s) {
              return DropdownMenuItem(value: s, child: Text(s));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _defaultLanguage = val);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _countryCtrl,
                  labelText: 'Default Localization Country',
                  hintText: 'India',
                  prefixIcon: Icons.flag,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _currencyCtrl,
                  labelText: 'Default Localization Currency',
                  hintText: 'INR (₹)',
                  prefixIcon: Icons.monetization_on,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _timeZoneCtrl,
                  labelText: 'Default Timezone',
                  hintText: 'IST (UTC+5:30)',
                  prefixIcon: Icons.access_time,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _dateFormatCtrl,
                  labelText: 'Date Format Preference',
                  hintText: 'yyyy-MM-dd',
                  prefixIcon: Icons.calendar_month,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _timeFormatCtrl,
                  labelText: 'Time Format Preference',
                  hintText: '12-Hour (hh:mm AM/PM)',
                  prefixIcon: Icons.timer_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Number Format Pattern', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _numberFormat,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: ['1,23,456.78 (Indian)', '123,456.78 (US)', '123.456,78 (European)'].map((s) {
              return DropdownMenuItem(value: s, child: Text(s));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _numberFormat = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAiTab(SystemSettings settings) {
    return Column(
      children: [
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AI Cognitive Engine Switches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('AI Services Suite Enabled', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Master switch to enable/disable all AI engines globally.'),
                value: _aiFeaturesEnabled,
                onChanged: (val) => setState(() => _aiFeaturesEnabled = val),
              ),
              SwitchListTile(
                title: const Text('AI Personal Tutor Uploader', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Allow AI tutor interaction modules on student learning dashboards.'),
                value: _aiTutorEnabled,
                onChanged: (val) => setState(() => _aiTutorEnabled = val),
              ),
              SwitchListTile(
                title: const Text('AI Automatic Doubt Solver', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Allow automated OCR/doubt solving responses to student questions.'),
                value: _aiDoubtSolverEnabled,
                onChanged: (val) => setState(() => _aiDoubtSolverEnabled = val),
              ),
              SwitchListTile(
                title: const Text('Image OCR Parsing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Allow uploading pictures of textbooks to query details.'),
                value: _imageQuestionEnabled,
                onChanged: (val) => setState(() => _imageQuestionEnabled = val),
              ),
              SwitchListTile(
                title: const Text('AI Quiz Generator Engine', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Allow teachers to generate mock quizzes from text chapters automatically.'),
                value: _aiQuizGeneratorEnabled,
                onChanged: (val) => setState(() => _aiQuizGeneratorEnabled = val),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _freeLimitCtrl,
                      labelText: 'Free Daily AI Queries Limit',
                      hintText: '5',
                      prefixIcon: Icons.data_usage,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _premiumLimitCtrl,
                      labelText: 'Premium Daily AI Queries Limit',
                      hintText: '100',
                      prefixIcon: Icons.workspace_premium,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Text-To-Speech (TTS) Voice Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('TTS Voice Narration Enabled', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Allow student mobile apps to narrate quiz questions/answers verbally.'),
                value: _aiVoiceEnabled,
                onChanged: (val) => setState(() => _aiVoiceEnabled = val),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('TTS Simulated Voice Gender:  ', style: TextStyle(fontWeight: FontWeight.bold)),
                  ChoiceChip(
                    label: const Text('Female Voice'),
                    selected: _voiceGender == 'Female',
                    onSelected: (val) {
                      if (val) setState(() => _voiceGender = 'Female');
                    },
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Male Voice'),
                    selected: _voiceGender == 'Male',
                    onSelected: (val) {
                      if (val) setState(() => _voiceGender = 'Male');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _voiceSpeedCtrl,
                labelText: 'TTS Speech Rate Speed (0.5x - 2.0x)',
                hintText: '1.0',
                prefixIcon: Icons.speed,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _voiceVolumeCtrl,
                labelText: 'TTS Audio Output Volume (0.0 - 1.0)',
                hintText: '0.8',
                prefixIcon: Icons.volume_up,
              ),
              const Divider(height: 32),
              const Text('TTS Browser Synthesis Simulator Test', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _ttsTextCtrl,
                labelText: 'Test Speech Message Text',
                hintText: 'Welcome to Agarwal Hub...',
                prefixIcon: Icons.chat_bubble_outline,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
                    icon: Icon(_isTtsSpeaking ? Icons.volume_up : Icons.play_arrow),
                    label: Text(_isTtsSpeaking ? 'Speaking...' : 'Play Speech'),
                    onPressed: () {
                      final speed = double.tryParse(_voiceSpeedCtrl.text) ?? 1.0;
                      final volume = double.tryParse(_voiceVolumeCtrl.text) ?? 0.8;
                      _speakTTS(_ttsTextCtrl.text.trim(), _voiceGender, speed, volume);
                    },
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Speech'),
                    onPressed: _stopTTS,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMonetizationTab(SystemSettings settings) {
    return Column(
      children: [
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Monetization Master Switches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Global Subscriptions Portal Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Toggle monetization subscriptions systems on/off.'),
                value: _monetizationEnabled,
                onChanged: (val) => setState(() => _monetizationEnabled = val),
              ),
              SwitchListTile(
                title: const Text('Premium Scholar System Badges', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Displays premium scholar badge on profiles of premium package users.'),
                value: _premiumSystemEnabled,
                onChanged: (val) => setState(() => _premiumSystemEnabled = val),
              ),
              SwitchListTile(
                title: const Text('Display Banner & Interstitial Advertisements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Deploy Google AdMob ads to free tier active users.'),
                value: _adsEnabled,
                onChanged: (val) => setState(() => _adsEnabled = val),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _freeTrialDaysCtrl,
                      labelText: 'Free Trial Trial Period (Days)',
                      hintText: '7',
                      prefixIcon: Icons.card_giftcard,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Payment Integration Environment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _paymentGatewayStatus,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          items: ['Active', 'Sandbox', 'Inactive'].map((s) {
                            return DropdownMenuItem(value: s, child: Text(s));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _paymentGatewayStatus = val);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Active Subscriptions Billing Plans Packages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Divider(height: 32),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: settings.subscriptionPlans.length,
                itemBuilder: (context, index) {
                  final plan = settings.subscriptionPlans[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(plan['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  const SizedBox(width: 10),
                                  if (plan['badge'] != null && plan['badge'].toString().isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.secondaryOrange, borderRadius: BorderRadius.circular(6)),
                                      child: Text(plan['badge'], style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                    )
                                ],
                              ),
                              Text('₹${plan['price']} / ${plan['duration']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Details: ${plan['description']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('Features: ${plan['features']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMaintenanceTab(SystemSettings settings) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Portal Upgrades & Maintenance Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Active Maintenance Lockout Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Lock portal access for students/teachers while doing system upgrades.'),
            value: _maintenanceModeEnabled,
            onChanged: (val) => setState(() => _maintenanceModeEnabled = val),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _maintenanceMsgCtrl,
            labelText: 'Under Maintenance Message Title',
            hintText: 'Portal is currently undergoing scheduled database upgrades...',
            prefixIcon: Icons.lock_clock,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _scheduledTimeCtrl,
            labelText: 'Scheduled Duration Details',
            hintText: 'e.g. June 15, 02:00 AM to 04:00 AM IST',
            prefixIcon: Icons.calendar_today,
          ),
          const Divider(height: 32),
          const Text('Play Store / App Store App Version Tracking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Enforce Hard Force Upgrade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Force students to update mobile app if version is below minimum supported.'),
            value: _forceUpdateEnabled,
            onChanged: (val) => setState(() => _forceUpdateEnabled = val),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _currentVersionCtrl,
                  labelText: 'Current Loaded Version',
                  hintText: '1.2.0',
                  prefixIcon: Icons.info_outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _latestVersionCtrl,
                  labelText: 'Latest Available Version',
                  hintText: '1.2.0',
                  prefixIcon: Icons.system_update,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _minVersionCtrl,
                  labelText: 'Minimum Supported Version',
                  hintText: '1.0.0',
                  prefixIcon: Icons.warning_amber_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _updateMsgCtrl,
            labelText: 'Force Upgrade Alert Message text',
            hintText: 'A newer secure upgrade is available. Please update the application...',
            prefixIcon: Icons.chat,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _playStoreCtrl,
                  labelText: 'Google Play Store Uploader Link',
                  hintText: 'https://play.google.com/store...',
                  prefixIcon: Icons.shop,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _appStoreCtrl,
                  labelText: 'Apple App Store link',
                  hintText: 'https://apps.apple.com...',
                  prefixIcon: Icons.phone_iphone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _websiteLinkCtrl,
                  labelText: 'App Landing Website Link',
                  hintText: 'https://agarwalknowledgehub.com',
                  prefixIcon: Icons.web,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _privacyCtrl,
                  labelText: 'Privacy Policy URL',
                  hintText: 'https://agarwalknowledgehub.com/privacy',
                  prefixIcon: Icons.privacy_tip_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _termsCtrl,
                  labelText: 'Terms & Conditions URL',
                  hintText: 'https://agarwalknowledgehub.com/terms',
                  prefixIcon: Icons.gavel,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBackupTab(SystemSettings settings, SettingsViewModel settingsVm, UserProfile user) {
    return Column(
      children: [
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Automated Database Backup Configurations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Enable Auto-Scheduled Backups', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Store backup snapshot to secure storage bucket automatically.'),
                value: _autoBackupEnabled,
                onChanged: (val) => setState(() => _autoBackupEnabled = val),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Backup Schedule Frequency', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _backupSchedule,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          items: ['Daily', 'Weekly', 'Monthly'].map((s) {
                            return DropdownMenuItem(value: s, child: Text(s));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _backupSchedule = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _retentionCtrl,
                      labelText: 'Data Retention Window (Days)',
                      hintText: '365',
                      prefixIcon: Icons.delete_sweep_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Trigger Manual Cloud Storage Backup snapshot', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    icon: _isBackupInProgress 
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.cloud_upload),
                    label: Text(_isBackupInProgress ? 'Backing Up...' : 'Backup Database Now'),
                    onPressed: _isBackupInProgress ? null : () async {
                      setState(() {
                        _isBackupInProgress = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      await settingsVm.triggerBackup(user.name);
                      setState(() {
                        _isBackupInProgress = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Manual database backup snapshot saved! 💾'), backgroundColor: Colors.green),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Backup Snapshots History Registry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Divider(height: 32),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: settings.backupHistory.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, idx) {
                  final bak = settings.backupHistory[idx];
                  return ListTile(
                    leading: const Icon(Icons.backup_table_sharp, color: AppColors.primaryBlue),
                    title: Text('${bak['type']} (${bak['size']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('Creator: ${bak['creator']} | Date: ${bak['date']} | Status: ${bak['status']}'),
                    trailing: TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: AppColors.secondaryOrange),
                      icon: const Icon(Icons.restore, size: 16),
                      label: const Text('Restore'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (confirmCtx) => AlertDialog(
                            title: const Text('Confirm destructive restore'),
                            content: Text(
                              'WARNING: Restoring backup ${bak['id']} dated ${bak['date']} will overwrite all current system parameters, active rosters, homework assignments, and class structures. This action cannot be undone.\n\nAre you sure you want to proceed?'
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(confirmCtx),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                onPressed: () async {
                                  Navigator.pop(confirmCtx);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (loadingCtx) => const AlertDialog(
                                      content: Row(
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(width: 24),
                                          Text('Restoring system database snapshot...', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  );
                                  await settingsVm.restoreBackup(bak['id']!);
                                  Navigator.pop(context); // Close loading dialog
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Database restored successfully! 🔄'), backgroundColor: Colors.green),
                                  );
                                },
                                child: const Text('Restore Destructively'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildAuditLogsTab(EnterpriseProvider entProvider) {
    // Audit search/filters implementation
    final List<AuditLog> filteredLogs = entProvider.auditLogs.where((log) {
      final query = _logSearchQuery.toLowerCase();
      final matchesQuery = log.operatorName.toLowerCase().contains(query) ||
          log.description.toLowerCase().contains(query) ||
          log.actionType.toLowerCase().contains(query);

      final matchesAction = _logFilterAction == 'All' || log.actionType == _logFilterAction;
      final matchesRole = _logFilterRole == 'All' || log.operatorRole == _logFilterRole;

      return matchesQuery && matchesAction && matchesRole;
    }).toList();

    // Pagination bounds
    final int totalLogsCount = filteredLogs.length;
    final int totalPages = (totalLogsCount / _logPageSize).ceil().clamp(1, 9999);
    final int startOffset = (_logCurrentPage - 1) * _logPageSize;
    final int endOffset = (startOffset + _logPageSize).clamp(0, totalLogsCount);
    final List<AuditLog> paginatedLogs = filteredLogs.sublist(startOffset, endOffset);

    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Audit Action Registry Logs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search Operators / Actions...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _logSearchQuery = val.trim();
                      _logCurrentPage = 1;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _logFilterAction,
                items: ['All', 'Login', 'Logout', 'Upload', 'Delete', 'Settings'].map((act) {
                  return DropdownMenuItem(value: act, child: Text(act));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _logFilterAction = val;
                      _logCurrentPage = 1;
                    });
                  }
                },
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _logFilterRole,
                items: ['All', 'Super Admin', 'Admin', 'Teacher', 'Parent'].map((r) {
                  return DropdownMenuItem(value: r, child: Text(r));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _logFilterRole = val;
                      _logCurrentPage = 1;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (paginatedLogs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No matching audit registry logs found.'),
              ),
            )
          else ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Timestamp', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Operator Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Action Type', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: paginatedLogs.map((log) {
                  return DataRow(cells: [
                    DataCell(Text(log.timestamp.toString().substring(0, 19))),
                    DataCell(Text(log.operatorName)),
                    DataCell(Text(log.operatorRole)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: log.actionType == 'Login' 
                              ? Colors.green.withOpacity(0.1) 
                              : (log.actionType == 'Delete' ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          log.actionType,
                          style: TextStyle(
                            color: log.actionType == 'Login' 
                                ? Colors.green 
                                : (log.actionType == 'Delete' ? Colors.red : Colors.blue),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(log.description)),
                  ]);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Displaying logs ${startOffset + 1} - $endOffset of $totalLogsCount'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 14),
                      onPressed: _logCurrentPage > 1 
                          ? () => setState(() => _logCurrentPage--) 
                          : null,
                    ),
                    Text('Page $_logCurrentPage of $totalPages'),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 14),
                      onPressed: _logCurrentPage < totalPages 
                          ? () => setState(() => _logCurrentPage++) 
                          : null,
                    ),
                  ],
                )
              ],
            )
          ]
        ],
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
  List<Map<String, String>> _records = [];
  List<Map<String, String>> _deletedRecords = [];

  // Stats states
  String _operationalStatus = 'Optimal';
  String _encryptionKeyMode = 'AES-256 Enabled';

  @override
  void initState() {
    super.initState();
    _records = _getSimulatedData();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(GenericRolePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title) {
      _records = _getSimulatedData();
      _deletedRecords.clear();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  String _getKeyLabel(String key) {
    switch (key) {
      case 'name': return 'Name / Title';
      case 'code': return 'Branch Code';
      case 'address': return 'Address';
      case 'head': return 'Head of Branch';
      case 'phone': return 'Phone Number';
      case 'status': return 'Status';
      case 'child': return 'Student Child';
      case 'class': return 'Class Section';
      case 'email': return 'Email Address';
      case 'room': return 'Room Number';
      case 'strength': return 'Room Strength';
      case 'teacher': return 'Class Teacher';
      case 'date': return 'Date';
      case 'venue': return 'Venue';
      case 'cost': return 'Ticket/Entry Cost';
      case 'coordinator': return 'Coordinator Name';
      case 'issuedTo': return 'Issued To';
      case 'designation': return 'Designation Type';
      case 'transaction': return 'Transaction ID';
      case 'student': return 'Student Name';
      case 'amount': return 'Amount Paid';
      case 'method': return 'Payment Method';
      case 'detail_1': return 'Record Name';
      case 'detail_2': return 'Category';
      case 'detail_3': return 'Supervisor / Type';
      default: return key.toUpperCase();
    }
  }

  void _showAddEditDialog({Map<String, String>? existingItem, int? index}) {
    final bool isDark = widget.isDark;
    final List<String> formKeys = _records.isNotEmpty 
        ? _records.first.keys.toList() 
        : ['name', 'status'];

    final Map<String, TextEditingController> controllers = {};
    for (var k in formKeys) {
      if (k != 'status') {
        controllers[k] = TextEditingController(text: existingItem != null ? existingItem[k] : '');
      }
    }
    String currentStatus = existingItem != null ? (existingItem['status'] ?? 'Active') : 'Active';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  Icon(existingItem != null ? Icons.edit_note : Icons.add_circle_outline, color: AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    existingItem != null ? 'Edit Details' : 'Add New Record',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...controllers.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getKeyLabel(entry.key),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: entry.value,
                                decoration: InputDecoration(
                                  hintText: 'Enter ${_getKeyLabel(entry.key).toLowerCase()}',
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      
                      const Text(
                        'Status',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: currentStatus,
                            isExpanded: true,
                            items: ['Active', 'Primary', 'Full', 'Upcoming', 'Scheduled', 'Planned', 'Generated', 'Printed', 'Paid', 'Pending', 'Completed', 'In-Progress']
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() {
                                  currentStatus = val;
                                });
                              }
                            },
                          ),
                        ),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final Map<String, String> newItem = {};
                    controllers.forEach((k, ctrl) {
                      newItem[k] = ctrl.text.trim();
                    });
                    newItem['status'] = currentStatus;

                    final mainKey = formKeys.first;
                    if ((newItem[mainKey] ?? '').isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill out the primary field.'), backgroundColor: Colors.orange),
                      );
                      return;
                    }

                    setState(() {
                      if (existingItem != null && index != null) {
                        _records[index] = newItem;
                      } else {
                        _records.add(newItem);
                      }
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(existingItem != null ? 'Record updated successfully! 💾' : 'New record added successfully! 🎉'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text(existingItem != null ? 'Save Changes' : 'Add Record'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showViewDetailsDialog(Map<String, String> item) {
    final bool isDark = widget.isDark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Text(
                'View Record Details',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: item.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          '${_getKeyLabel(entry.key)}:',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showTrashArchiveDialog() {
    final bool isDark = widget.isDark;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  const Icon(Icons.delete_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.title} Delete History',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              content: SizedBox(
                width: 450,
                height: 350,
                child: _deletedRecords.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_delete_outlined, size: 48, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('No deleted history items.'),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _deletedRecords.length,
                        separatorBuilder: (c, i) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = _deletedRecords[index];
                          final primaryVal = item.values.first;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              primaryVal,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            subtitle: Text(
                              'Status: ${item['status']}',
                              style: const TextStyle(fontSize: 11),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _records.add(item);
                                      _deletedRecords.removeAt(index);
                                    });
                                    setDialogState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Record restored successfully! 🔄'), backgroundColor: Colors.green),
                                    );
                                  },
                                  icon: const Icon(Icons.restore, size: 14, color: Colors.green),
                                  label: const Text('Restore', style: TextStyle(color: Colors.green, fontSize: 11)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_forever, size: 18, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _deletedRecords.removeAt(index);
                                    });
                                    setDialogState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Record deleted permanently! 🗑️'), backgroundColor: Colors.red),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSyncSettingsDialog() {
    final bool isDark = widget.isDark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(Icons.sync, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              const Text('Synchronization Panel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Force manual cache refresh and check data integrity against Firebase cloud stores.',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.cloud_done_outlined, color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  Text('Cloud Stream Sync: Realtime Active', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                ],
              ),
            ],
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sync Done! Active count: ${_records.length} items checked successfully. 🔄💾'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Refresh Sync'),
            ),
          ],
        );
      },
    );
  }

  void _showOperationalStatusDialog() {
    final bool isDark = widget.isDark;
    String selectedStatus = _operationalStatus;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  Icon(Icons.offline_bolt_outlined, color: AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  const Text('Operational Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configure operational flags to signal ongoing module maintenance or downtime to active clients.',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  ...['Optimal', 'Maintenance', 'Degraded Performance'].map((status) {
                    return RadioListTile<String>(
                      title: Text(status, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      value: status,
                      groupValue: selectedStatus,
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedStatus = val;
                          });
                         }
                       },
                     );
                   }),
                 ],
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
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                   ),
                   onPressed: () {
                     setState(() {
                       _operationalStatus = selectedStatus;
                     });
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: Text('Module status changed to: $_operationalStatus! ⚙️'),
                         backgroundColor: Colors.green,
                       ),
                     );
                   },
                   child: const Text('Apply Status'),
                 ),
               ],
             );
           },
         );
       },
     );
   }

   void _showEncryptionKeysDialog() {
     final bool isDark = widget.isDark;
     String selectedKey = _encryptionKeyMode;
     showDialog(
       context: context,
       builder: (context) {
         return StatefulBuilder(
           builder: (context, setDialogState) {
             return AlertDialog(
               backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
               title: Row(
                 children: [
                   Icon(Icons.security, color: AppColors.primaryBlue),
                   const SizedBox(width: 8),
                   const Text('Configure Encryption', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                 ],
               ),
               content: Column(
                 mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text(
                     'Toggle security payload standards for secure client-server socket tunnels.',
                     style: TextStyle(fontSize: 13, height: 1.4),
                   ),
                   const SizedBox(height: 16),
                   ...['AES-256 Enabled', 'ChaCha20-Poly1305', 'RSA-4096 Hybrid'].map((key) {
                     return RadioListTile<String>(
                       title: Text(key, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                       value: key,
                       groupValue: selectedKey,
                       onChanged: (val) {
                         if (val != null) {
                           setDialogState(() {
                             selectedKey = val;
                           });
                         }
                       },
                     );
                   }),
                 ],
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
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                   ),
                   onPressed: () {
                     setState(() {
                       _encryptionKeyMode = selectedKey;
                     });
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: Text('Encryption updated to: $_encryptionKeyMode! 🛡️'),
                         backgroundColor: Colors.green,
                       ),
                     );
                   },
                   child: const Text('Save Standard'),
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
    final bool isDark = widget.isDark;
    final String query = _searchController.text.toLowerCase();
    final List<Map<String, String>> filteredRecords = _records.where((item) {
      return item.values.any((val) => val.toLowerCase().contains(query));
    }).toList();
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
                      setState(() {
                        _records = _getSimulatedData();
                        _deletedRecords.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.title} details successfully synced & reset! 🔄')),
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
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isMobile ? 3.5 : 2.8,
            children: [
              GestureDetector(
                onTap: _showSyncSettingsDialog,
                child: _buildStatsCard('Total Items Sync', '${filteredRecords.length}', Icons.sync, Colors.blue, isMobile),
              ),
              GestureDetector(
                onTap: _showOperationalStatusDialog,
                child: _buildStatsCard('Operational Status', _operationalStatus, Icons.check_circle_outline, Colors.green, isMobile),
              ),
              GestureDetector(
                onTap: _showEncryptionKeysDialog,
                child: _buildStatsCard('Encryption Keys', _encryptionKeyMode, Icons.security, Colors.orange, isMobile),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
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
                Flex(
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Operational Logs & Records',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.grey),
                      tooltip: 'View Delete History (Trash)',
                      onPressed: _showTrashArchiveDialog,
                    ),
                    if (isMobile) const SizedBox(height: 12),
                    if (!isMobile) const Spacer(),
                    SizedBox(
                      width: isMobile ? double.infinity : 200,
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
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onPressed: () => _showAddEditDialog(),
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('Add Record', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredRecords.length,
                  separatorBuilder: (c, i) => const Divider(height: 16),
                  itemBuilder: (context, idx) {
                    final item = filteredRecords[idx];
                    final keys = item.keys.toList();
                    final originalIndex = _records.indexOf(item);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () => _showViewDetailsDialog(item),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
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
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, size: 16, color: Colors.blue),
                            tooltip: 'View Details',
                            onPressed: () => _showViewDetailsDialog(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.green),
                            tooltip: 'Edit',
                            onPressed: () => _showAddEditDialog(existingItem: item, index: originalIndex),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                            tooltip: 'Delete',
                            onPressed: () {
                              setState(() {
                                _deletedRecords.add(item);
                                _records.removeAt(originalIndex);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Record moved to Delete History.'),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    textColor: Colors.yellow,
                                    onPressed: () {
                                      setState(() {
                                        _records.insert(originalIndex, item);
                                        _deletedRecords.remove(item);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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
  final Set<String> _selectedUids = {};

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
                              await webVm.syncParentForStudent(student);
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
                    Row(
                      children: [
                        Checkbox(
                          value: filteredParents.isNotEmpty && _selectedUids.length == filteredParents.length,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedUids.addAll(filteredParents.map((p) => p.uid));
                              } else {
                                _selectedUids.clear();
                              }
                            });
                          },
                        ),
                        const Text('Select All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 16),
                        const Text('Parent Roster & Activity Surveillance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Row(
                      children: [
                        if (_selectedUids.isNotEmpty) ...[
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.delete_sweep, size: 18),
                            label: Text('Delete Selected (${_selectedUids.length})'),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (confirmCtx) => AlertDialog(
                                  title: const Text('Confirm Bulk Deletion'),
                                  content: Text('Are you sure you want to delete ${_selectedUids.length} selected parents? They will be moved to Delete History.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(confirmCtx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(confirmCtx, true),
                                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                                      child: const Text('Move to History'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                final selectedParents = filteredParents.where((p) => _selectedUids.contains(p.uid)).toList();
                                for (final p in selectedParents) {
                                  await webVm.moveToTrash(p);
                                }
                                setState(() {
                                  _selectedUids.clear();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Selected parents moved to Delete History! 🗑️')),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                        ],
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.history, size: 18),
                          label: const Text('Delete History'),
                          onPressed: () => _showDeleteHistoryDialog(context, AppStrings.roleParent, webVm),
                        ),
                        if (isSuperAdmin) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: const Text(
                              'Super Admin Active 🛡️',
                              style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
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
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _selectedUids.contains(parent.uid),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedUids.add(parent.uid);
                                    } else {
                                      _selectedUids.remove(parent.uid);
                                    }
                                  });
                                },
                              ),
                              const SizedBox(width: 4),
                              CircleAvatar(
                                backgroundColor: parent.isOnline ? Colors.green : Colors.grey,
                                foregroundColor: Colors.white,
                                child: const Icon(Icons.family_restroom),
                              ),
                            ],
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
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (confirmCtx) => AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: Text('Are you sure you want to delete ${parent.name}? They will be moved to Delete History.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(confirmCtx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(confirmCtx, true),
                                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                                          child: const Text('Move to History'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await webVm.moveToTrash(parent);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${parent.name} moved to Delete History! 🗑️')),
                                    );
                                  }
                                },
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

void _showDeleteHistoryDialog(BuildContext context, String role, WebPanelViewModel webVm) {
  // Load latest trash list from Firestore
  webVm.loadTrash();

  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final roleTrashList = webVm.trashList.where((u) => u.role == role).toList();

          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.delete_outline, color: Colors.red),
                const SizedBox(width: 8),
                Text('Delete History & Archive ($role)'),
              ],
            ),
            content: SizedBox(
              width: 500,
              height: 400,
              child: roleTrashList.isEmpty
                  ? Center(
                      child: Text(
                        'No deleted records found for $role.',
                        style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    )
                  : ListView.builder(
                      itemCount: roleTrashList.length,
                      itemBuilder: (c, idx) {
                        final item = roleTrashList[idx];
                        return ListTile(
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Email: ${item.email} | Phone: ${item.phone}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.settings_backup_restore, color: Colors.green),
                                tooltip: 'Restore Record',
                                onPressed: () async {
                                  await webVm.restoreFromTrash(item);
                                  setDialogState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${item.name} restored successfully! 🟢')),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever, color: Colors.red),
                                tooltip: 'Delete Permanently',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (confirmCtx) => AlertDialog(
                                      title: const Text('Confirm Permanent Deletion'),
                                      content: Text('Are you sure you want to permanently delete ${item.name}? This cannot be undone.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(confirmCtx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(confirmCtx, true),
                                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                                          child: const Text('Delete Forever'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await webVm.permanentlyDelete(item.uid);
                                    setDialogState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${item.name} permanently deleted! ⛔')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );
}
