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

class WebDashboardShell extends StatefulWidget {
  const WebDashboardShell({super.key});

  @override
  State<WebDashboardShell> createState() => _WebDashboardShellState();
}

class _WebDashboardShellState extends State<WebDashboardShell> {
  int _selectedMenuIndex = 0;
  bool _isSidebarCollapsed = false;

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
    {'title': 'Students', 'icon': Icons.people_outline},
    {'title': 'Teachers', 'icon': Icons.assignment_ind_outlined},
    {'title': 'Classes & Subjects', 'icon': Icons.class_outlined},
    {'title': 'Resource Library', 'icon': Icons.menu_book_outlined},
    {'title': 'Homework', 'icon': Icons.assignment_outlined},
    {'title': 'Quiz Builder', 'icon': Icons.quiz_outlined},
    {'title': 'Attendance', 'icon': Icons.calendar_today_outlined},
    {'title': 'Notice Board', 'icon': Icons.announcement_outlined},
    {'title': 'Story Expire', 'icon': Icons.history_toggle_off_outlined},
    {'title': 'AI Doubts', 'icon': Icons.chat_bubble_outline},
    {'title': 'Push Alerts', 'icon': Icons.notifications_active_outlined},
    {'title': 'Reports', 'icon': Icons.analytics_outlined},
    {'title': 'System Settings', 'icon': Icons.settings_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final user = authVm.userProfile;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double width = MediaQuery.sizeOf(context).width;

    if (user == null) {
      return const LoginScreen();
    }

    return Scaffold(
      body: Row(
        children: [
          // Collapsible Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isSidebarCollapsed ? 76 : 280,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border(
                right: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: Column(
              children: [
                _buildSidebarHeader(user, isDark),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = _selectedMenuIndex == index;
                      return _buildSidebarItem(item, isSelected, index, isDark);
                    },
                  ),
                ),
                const Divider(height: 1),
                _buildSidebarFooter(context, isDark),
              ],
            ),
          ),
          
          // Main Content Container
          Expanded(
            child: Column(
              children: [
                // Top Navigation Bar
                _buildTopBar(context, user, isDark),
                
                // Active Panel View Area
                Expanded(
                  child: Container(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    child: _buildActivePanel(context, _selectedMenuIndex, user, isDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader(UserProfile user, bool isDark) {
    if (_isSidebarCollapsed) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        child: const Icon(Icons.school, color: AppColors.primaryBlue, size: 28),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      height: 100,
      child: Row(
        children: [
          const Icon(Icons.school, color: AppColors.primaryBlue, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Agarwal Knowledge',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Hub Portal',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebarItem(Map<String, dynamic> item, bool isSelected, int index, bool isDark) {
    return ListTile(
      leading: Icon(
        item['icon'],
        color: isSelected ? AppColors.primaryBlue : Colors.grey,
      ),
      title: _isSidebarCollapsed
          ? null
          : Text(
              item['title'],
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
                color: isSelected
                    ? (isDark ? Colors.white : AppColors.primaryBlue)
                    : Colors.grey,
              ),
            ),
      selected: isSelected,
      selectedTileColor: AppColors.primaryBlue.withOpacity(0.08),
      onTap: () {
        setState(() {
          _selectedMenuIndex = index;
        });
      },
    );
  }

  Widget _buildSidebarFooter(BuildContext context, bool isDark) {
    return ListTile(
      leading: const Icon(Icons.logout, color: AppColors.secondaryOrange),
      title: _isSidebarCollapsed
          ? null
          : const Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryOrange, fontSize: 13),
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
                  setState(() {
                    _isSidebarCollapsed = !_isSidebarCollapsed;
                  });
                },
              ),
              const SizedBox(width: 12),
              Text(
                _menuItems[_selectedMenuIndex]['title'],
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ],
          ),
          
          Row(
            children: [
              // Theme switcher
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode_outlined),
                onPressed: () => themeProvider.toggleTheme(),
              ),
              const SizedBox(width: 16),
              
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivePanel(BuildContext context, int index, UserProfile user, bool isDark) {
    switch (index) {
      case 0:
        return SuperAdminDashboardPanel(isDark: isDark);
      case 1:
        return StudentManagementPanel(isDark: isDark);
      case 2:
        return TeacherManagementPanel(isDark: isDark);
      case 3:
        return ClassSubjectPanel(isDark: isDark);
      case 4:
        return ResourceUploadPanel(isDark: isDark);
      case 5:
        return HomeworkManagementPanel(isDark: isDark);
      case 6:
        return QuizBuilderPanel(isDark: isDark);
      case 7:
        return AttendanceManagementPanel(isDark: isDark);
      case 8:
        return NoticeBoardPanel(isDark: isDark);
      case 9:
        return StoryUploadPanel(isDark: isDark);
      case 10:
        return DoubtPanel(isDark: isDark);
      case 11:
        return NotificationsPanel(isDark: isDark);
      case 12:
        return ReportsPanel(isDark: isDark);
      case 13:
        return WebSettingsPanel(isDark: isDark);
      default:
        return Center(child: Text('${_menuItems[index]['title']} coming soon...'));
    }
  }
}

// ==========================================
// SUB SCREEN 1: SUPER ADMIN DASHBOARD
// ==========================================
class SuperAdminDashboardPanel extends StatelessWidget {
  final bool isDark;

  const SuperAdminDashboardPanel({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final webVm = Provider.of<WebPanelViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row of stats cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
            children: [
              _buildStatCard('Total Students', '${webVm.totalStudents}', Icons.people, AppColors.primaryBlue),
              _buildStatCard('Total Teachers', '${webVm.totalTeachers}', Icons.assignment_ind, AppColors.secondaryOrange),
              _buildStatCard('Active Classes', '${webVm.totalClasses}', Icons.class_, AppColors.accentGreen),
              _buildStatCard('Doubt Inquiries', '${webVm.doubtQueries.where((d) => d['status'] == 'Pending').length}', Icons.chat_bubble, Colors.purple),
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

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
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
  final _classController = TextEditingController();
  final _rollController = TextEditingController();

  void _onAddStudent() {
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);
    final student = UserProfile(
      uid: 'std_${DateTime.now().millisecondsSinceEpoch}',
      role: AppStrings.roleStudent,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: '',
      address: '',
      userClass: _classController.text.trim(),
      rollNumber: _rollController.text.trim(),
      gender: '',
      dob: '',
      admissionNumber: 'ADM-${DateTime.now().millisecond}',
      school: 'Agarwal Knowledge Hub',
      parentName: '',
      parentMobile: '',
      emergencyContact: '',
      profilePhotoUrl: '',
      createdDate: DateTime.now(),
      lastLogin: DateTime.now(),
    );

    webVm.addStudent(student);
    
    _nameController.clear();
    _phoneController.clear();
    _classController.clear();
    _rollController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student registered successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    final webVm = Provider.of<WebPanelViewModel>(context);

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
                const Text('Students Roster', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
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
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Class: ${student.userClass} | Phone: ${student.phone}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error),
                          onPressed: () => webVm.deleteStudent(student.uid),
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
                labelText: 'Phone Number',
                hintText: 'e.g. +919876543210',
                prefixIcon: Icons.phone_android_outlined,
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
    
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Teacher registered successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    final webVm = Provider.of<WebPanelViewModel>(context);

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
                const Text('Teachers Roster', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: webVm.teachersList.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final teacher = webVm.teachersList[index];
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.school)),
                        title: Text(teacher.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Role: ${teacher.role} | Phone: ${teacher.phone}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error),
                          onPressed: () => webVm.deleteTeacher(teacher.uid),
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
  final _titleController = TextEditingController();
  final _classController = TextEditingController();
  final _descController = TextEditingController();

  void _onUpload() {
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);
    final hw = Homework(
      id: 'hw_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      userClass: _classController.text.trim(),
      fileUrl: '',
      fileName: '',
      deadline: DateTime.now().add(const Duration(days: 2)),
      teacherId: 'web_admin',
      teacherName: 'Super Admin',
      createdDate: DateTime.now(),
    );

    webVm.uploadHomework(hw);

    _titleController.clear();
    _classController.clear();
    _descController.clear();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Homework task created successfully.')));
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
              const Text('Create New Homework', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _titleController,
                labelText: 'Task Title',
                hintText: 'e.g. Fractions Worksheet 1',
                prefixIcon: Icons.assignment,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _classController,
                labelText: 'Assign Class',
                hintText: 'e.g. Class 5',
                prefixIcon: Icons.school,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descController,
                labelText: 'Description / Instructions',
                hintText: 'Page 30 questions 1 to 5...',
                prefixIcon: Icons.description,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Publish Homework',
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

  void _onPublish() {
    final webVm = Provider.of<WebPanelViewModel>(context, listen: false);
    final notice = Notice(
      id: 'ntc_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      type: 'General',
      createdDate: DateTime.now(),
      sender: 'Super Admin',
    );

    webVm.publishNotice(notice);

    _titleController.clear();
    _contentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notice bulletin published successfully.')));
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
              const Text('Publish Notice Board Announcement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _titleController,
                labelText: 'Notice Title',
                hintText: 'e.g. Holiday Announcement',
                prefixIcon: Icons.announcement,
              ),
              const SizedBox(height: 16),
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
