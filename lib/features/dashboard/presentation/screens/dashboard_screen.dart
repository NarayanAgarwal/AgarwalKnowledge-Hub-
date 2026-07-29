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

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final dashVm = Provider.of<DashboardViewModel>(context);
    final user = authVm.userProfile;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: dashVm.isLoading
          ? _buildLoadingSkeleton()
          : RefreshIndicator(
              onRefresh: () => dashVm.loadDashboardData(user.userClass, user.uid),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Card
                    _buildGreetingCard(user, isDark),
                    
                    if (dashVm.stories.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildStoriesRow(dashVm, context),
                    ],
                    
                    const SizedBox(height: 24),
                    
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 15,
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
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  user.name.isNotEmpty ? user.name : 'Learner',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.userClass.isNotEmpty ? user.userClass : 'General Course',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white24,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              child: user.profilePhotoUrl.isNotEmpty
                  ? ClipOval(child: Image.network(user.profilePhotoUrl, fit: BoxFit.cover))
                  : const Icon(Icons.person, size: 36, color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 350.ms).slideY(begin: 0.1, end: 0.0);
  }

  Widget _buildSearchBar(DashboardViewModel dashVm, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        onChanged: dashVm.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search notes, videos, quizzes, notices...',
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
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
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
          'Quick Access',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.9,
          children: [
            _buildActionItem(
              context: context,
              icon: Icons.school_outlined,
              title: 'Classes',
              color: AppColors.primaryBlue,
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
              color: AppColors.secondaryOrange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoubtSupportScreen()),
                );
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.quiz_outlined,
              title: 'Quizzes',
              color: AppColors.accentGreen,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quiz module is accessible via individual classes!')),
                );
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.qr_code_scanner_outlined,
              title: 'QR Scan',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AttendanceDashboardScreen()),
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
    required Color color,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, DashboardViewModel dashVm, bool isDark) {
    // Calculate attendance percentage
    final total = dashVm.attendance.length;
    final present = dashVm.attendance.where((a) => a.status == 'Present').length;
    final percentage = total == 0 ? 0.85 : present / total; // Mock high if empty

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AttendanceDashboardScreen()),
        );
      },
      child: GlassContainer(
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              percent: percentage,
              center: Text(
                "${(percentage * 100).toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              progressColor: AppColors.accentGreen,
              backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.rocket_launch_outlined, color: Colors.white, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stuck with Homework?',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Get instant assistance with AI Doubt Support!',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.secondaryOrange,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DoubtSupportScreen()),
              );
            },
            child: const Text('Ask AI', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildTodayClasses(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Today\'s Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildClassTimeItem('09:00 AM', 'Mathematics - Fractions', 'Room 12', true),
                const Divider(),
                _buildClassTimeItem('11:00 AM', 'English Literature', 'Room 12', false),
                const Divider(),
                _buildClassTimeItem('02:00 PM', 'Computer Theory', 'Lab 1', false),
              ],
            ),
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
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent ? AppColors.secondaryOrange : null,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject,
                style: TextStyle(fontWeight: FontWeight.bold, color: isCurrent ? AppColors.primaryBlue : null),
              ),
              Text(room, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        if (isCurrent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.secondaryOrange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Live', style: TextStyle(color: AppColors.secondaryOrange, fontSize: 10, fontWeight: FontWeight.bold)),
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
        const Text('Latest Notice', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notice.type == 'Urgent'
                ? AppColors.error.withOpacity(0.08)
                : AppColors.primaryBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notice.type == 'Urgent' ? AppColors.error.withOpacity(0.3) : AppColors.primaryBlue.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(notice.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: notice.type == 'Urgent' ? AppColors.error : AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notice.type,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notice.content,
                style: const TextStyle(fontSize: 13, height: 1.4),
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
        const Text('Homework Due', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: dashVm.homeworkList.take(2).map((hw) {
              return ListTile(
                leading: const Icon(Icons.assignment_outlined, color: AppColors.secondaryOrange),
                title: Text(hw.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Deadline: ${hw.deadline.day}/${hw.deadline.month}'),
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
        const Text('Recent Lecture Material', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Card(
                color: isDark ? AppColors.darkSurface : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.picture_as_pdf_outlined, color: AppColors.error, size: 32),
                      const SizedBox(height: 8),
                      const Text('Notes PDFs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('${dashVm.notes.length} items', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                color: isDark ? AppColors.darkSurface : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.video_library_outlined, color: AppColors.primaryBlue, size: 32),
                      const SizedBox(height: 8),
                      const Text('Lecture Videos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('${dashVm.videos.length} videos', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
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
          'Classroom Stories',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dashVm.stories.length,
            itemBuilder: (context, index) {
              final story = dashVm.stories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
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
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.secondaryOrange, width: 3),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(story.mediaUrl),
                      backgroundColor: Colors.grey[200],
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
