import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/loading_skeleton.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../../classes/presentation/screens/class_selection_screen.dart';
import '../../../doubt_support/presentation/screens/doubt_support_screen.dart';
import '../../../homework/presentation/screens/homework_detail_screen.dart';
import '../../../stories/presentation/screens/story_viewer_screen.dart';
import '../../../attendance/presentation/screens/attendance_dashboard_screen.dart';
import '../../../study_play/presentation/screens/study_play_screen.dart';
import '../../../downloads/presentation/screens/downloads_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final dashVm = Provider.of<DashboardViewModel>(context);
    final user = authVm.userProfile;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final playroomBgColor = isDark ? Colors.grey[900] : const Color(0xFFF5F7FB);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: playroomBgColor,
      body: dashVm.isLoading
          ? _buildLoadingSkeleton()
          : RefreshIndicator(
              onRefresh: () => dashVm.loadDashboardData(user.userClass, user.uid),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Card
                    _buildGreetingCard(user, isDark),
                    
                    if (dashVm.stories.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildStoriesRow(dashVm, context),
                    ],
                    
                    const SizedBox(height: 20),
                    
                    // Search Bar
                    _buildSearchBar(dashVm, isDark),
                    
                    const SizedBox(height: 24),

                    if (dashVm.searchQuery.isNotEmpty) ...[
                      // Search Results
                      _buildSearchResults(dashVm, isDark),
                    ] else ...[
                      // Quick Action Grid
                      _buildQuickActions(context, isDark),
                      
                      const SizedBox(height: 24),
                      
                      // Attendance Card
                      _buildAttendanceCard(context, dashVm, isDark),
                      
                      const SizedBox(height: 24),
                      
                      // AI Doubt Support Banner
                      _buildAiSupportBanner(context, isDark),
                      
                      const SizedBox(height: 24),
                      
                      // Today's Classes timeline
                      _buildTodayClasses(isDark),
                      
                      const SizedBox(height: 24),
                      
                      // Latest Notice Board
                      _buildLatestNotice(dashVm, isDark),
                      
                      const SizedBox(height: 24),
                      
                      // Homework Summary
                      _buildHomeworkSummary(dashVm, context, isDark),
                      
                      const SizedBox(height: 24),
                      
                      // Recent Content (PDFs & Videos)
                      _buildRecentContent(dashVm, isDark),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGreetingCard(dynamic user, bool isDark) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2A5298), Color(0xFF1E3C72)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E3C72).withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello,',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.name.isNotEmpty ? user.name : 'Learner',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                      ),
                      child: Text(
                        user.userClass.isNotEmpty ? user.userClass : 'General Course',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white24,
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white,
                  child: user.profilePhotoUrl.isNotEmpty
                      ? ClipOval(child: Image.network(user.profilePhotoUrl, fit: BoxFit.cover))
                      : const Icon(Icons.person, size: 38, color: AppColors.primaryBlue),
                ),
              ),
            ],
          ),
        ),
        // Translucent background blobs for premium depth
        Positioned(
          right: -25,
          top: -25,
          child: CircleAvatar(
            radius: 65,
            backgroundColor: Colors.white.withOpacity(0.08),
          ),
        ),
        Positioned(
          left: -35,
          bottom: -35,
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white.withOpacity(0.06),
          ),
        ),
      ],
    ).animate().fade(duration: 400.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0));
  }

  Widget _buildSearchBar(DashboardViewModel dashVm, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade100,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextField(
        onChanged: dashVm.updateSearchQuery,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search notes, videos, quizzes, notices...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500),
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryBlue),
          suffixIcon: dashVm.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => dashVm.updateSearchQuery(""),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildSearchResults(DashboardViewModel dashVm, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Search Results (${dashVm.searchResults.length})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => dashVm.updateSearchQuery(""),
              child: const Text('Clear'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        dashVm.searchResults.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Text('No matching content found.'),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dashVm.searchResults.length,
                itemBuilder: (context, index) {
                  final item = dashVm.searchResults[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        item.runtimeType.toString() == 'Notice'
                            ? Icons.announcement_outlined
                            : item.runtimeType.toString() == 'Homework'
                                ? Icons.assignment_outlined
                                : Icons.description_outlined,
                        color: AppColors.primaryBlue,
                      ),
                      title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        item.runtimeType.toString() == 'Notice' ? item.content : 'Subject Materials',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Access ⚡',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold, color: AppColors.primaryBlue),
        ),
        const SizedBox(height: 14),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85,
          children: [
            _buildActionItem(
              context: context,
              icon: Icons.school_outlined,
              title: 'Classes',
              baseColor: const Color(0xFFE8F0FE),
              textColor: const Color(0xFF1A73E8),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClassSelectionScreen()),
                );
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.psychology_outlined,
              title: 'AI Support',
              baseColor: const Color(0xFFFFEFEF),
              textColor: const Color(0xFFFF5722),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoubtSupportScreen()),
                );
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.qr_code_scanner_outlined,
              title: 'QR Scan',
              baseColor: const Color(0xFFF3E8FD),
              textColor: const Color(0xFF9C27B0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AttendanceDashboardScreen()),
                );
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.toys_outlined,
              title: 'Play Study',
              baseColor: const Color(0xFFFFF0F5),
              textColor: const Color(0xFFE91E63),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyPlayScreen()),
                );
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.quiz_outlined,
              title: 'Quizzes',
              baseColor: const Color(0xFFE6F4EA),
              textColor: const Color(0xFF2E7D32),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quiz module is accessible via individual classes!')),
                );
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.download_for_offline_outlined,
              title: 'Downloads',
              baseColor: const Color(0xFFFFF8E1),
              textColor: const Color(0xFFFFB300),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DownloadsScreen()),
                );
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.notifications_active_outlined,
              title: 'Notices',
              baseColor: const Color(0xFFE8EAF6),
              textColor: const Color(0xFF3F51B5),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notice board is accessible in the Notice tab below!')),
                );
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              baseColor: const Color(0xFFE0F2F1),
              textColor: const Color(0xFF00695C),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color baseColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : baseColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white10 : baseColor.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.transparent : textColor.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(icon, color: textColor, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(delay: 50.ms, duration: 200.ms);
  }

  Widget _buildAttendanceCard(BuildContext context, DashboardViewModel dashVm, bool isDark) {
    final total = dashVm.attendance.length;
    final present = dashVm.attendance.where((a) => a.status == 'Present').length;
    final percentage = total == 0 ? 0.85 : present / total;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AttendanceDashboardScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade100,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              percent: percentage,
              center: Text(
                "${(percentage * 100).toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.primaryBlue),
              ),
              progressColor: AppColors.accentGreen,
              backgroundColor: isDark ? AppColors.darkBorder : Colors.grey.shade100,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Attendance Rate',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Keep it above 75% to remain eligible for term exams.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAiSupportBanner(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9900), Color(0xFFF15A24), Color(0xFFEC008C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF15A24).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.rocket_launch_outlined, color: Colors.white, size: 38),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stuck with Homework?',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                ),
                const SizedBox(height: 2),
                Text(
                  'Get instant assistance with AI Doubt Support!',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.secondaryOrange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DoubtSupportScreen()),
              );
            },
            child: const Text('Ask AI', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
          )
        ],
      ),
    );
  }

  Widget _buildTodayClasses(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Today\'s Schedule 📅', style: TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.grey.shade100,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              _buildClassTimeItem('09:00 AM', 'Mathematics - Fractions', 'Room 12', true),
              const Divider(height: 24),
              _buildClassTimeItem('11:00 AM', 'English Literature', 'Room 12', false),
              const Divider(height: 24),
              _buildClassTimeItem('02:00 PM', 'Computer Theory', 'Lab 1', false),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildClassTimeItem(String time, String subject, String room, bool isCurrent) {
    return Row(
      children: [
        Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isCurrent ? AppColors.secondaryOrange : Colors.grey,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isCurrent ? AppColors.primaryBlue : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(room, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        if (isCurrent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryOrange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('Live', style: TextStyle(color: AppColors.secondaryOrange, fontSize: 10, fontWeight: FontWeight.extrabold)),
          ),
      ],
    );
  }

  Widget _buildLatestNotice(DashboardViewModel dashVm, bool isDark) {
    if (dashVm.notices.isEmpty) return const SizedBox.shrink();
    final notice = dashVm.notices.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Latest Notice 📢', style: TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: notice.type == 'Urgent'
                ? AppColors.error.withOpacity(0.06)
                : AppColors.primaryBlue.withOpacity(0.04),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: notice.type == 'Urgent' ? AppColors.error.withOpacity(0.25) : AppColors.primaryBlue.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(notice.title, style: const TextStyle(fontWeight: FontWeight.extrabold, fontSize: 16))),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: notice.type == 'Urgent' ? AppColors.error : AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      notice.type,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.extrabold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notice.content,
                style: const TextStyle(fontSize: 13, height: 1.4, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHomeworkSummary(DashboardViewModel dashVm, BuildContext context, bool isDark) {
    if (dashVm.homeworkList.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Homework Due 📝', style: TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.grey.shade100,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: dashVm.homeworkList.take(2).map((hw) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFEF3EB),
                  child: Icon(Icons.assignment_outlined, color: AppColors.secondaryOrange),
                ),
                title: Text(hw.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Deadline: ${hw.deadline.day}/${hw.deadline.month}', style: const TextStyle(fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeworkDetailScreen(homework: hw),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentContent(DashboardViewModel dashVm, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lecture Materials 📚', style: TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.grey.shade100,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFFFEBEE),
                      radius: 24,
                      child: Icon(Icons.picture_as_pdf_outlined, color: AppColors.error, size: 26),
                    ),
                    const SizedBox(height: 12),
                    const Text('Notes PDFs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text('${dashVm.notes.length} items', style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.grey.shade100,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFE8F0FE),
                      radius: 24,
                      child: Icon(Icons.video_library_outlined, color: AppColors.primaryBlue, size: 26),
                    ),
                    const SizedBox(height: 12),
                    const Text('Lecture Videos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text('${dashVm.videos.length} videos', style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildStoriesRow(DashboardViewModel dashVm, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Classroom Stories 🎬',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 82,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dashVm.stories.length,
            itemBuilder: (context, index) {
              final story = dashVm.stories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryViewerScreen(stories: dashVm.stories),
                      ),
                    );
                  },
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [Colors.purple, Colors.pink, Colors.orange, Colors.purple],
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        backgroundImage: story.mediaUrl.isNotEmpty ? NetworkImage(story.mediaUrl) : null,
                        backgroundColor: Colors.amber[100],
                        child: story.mediaUrl.isEmpty ? const Text("📖", style: TextStyle(fontSize: 24)) : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          LoadingSkeleton(width: double.infinity, height: 140, borderRadius: 24),
          SizedBox(height: 24),
          LoadingSkeleton(width: double.infinity, height: 50, borderRadius: 16),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: LoadingSkeleton(width: 100, height: 100, borderRadius: 16)),
              SizedBox(width: 12),
              Expanded(child: LoadingSkeleton(width: 100, height: 100, borderRadius: 16)),
              SizedBox(width: 12),
              Expanded(child: LoadingSkeleton(width: 100, height: 100, borderRadius: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
