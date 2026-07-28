import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/services/academic_provider.dart';

class ReportCardScreen extends StatelessWidget {
  const ReportCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final acadProvider = Provider.of<AcademicProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Performance Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall KPIs card
                const Text('Performance Indicators (KPIs)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.4,
                  children: [
                    _buildKpiCard('Attendance Rate', '96%', Icons.calendar_today, AppColors.accentGreen),
                    _buildKpiCard('Homework Done', '92%', Icons.assignment_turned_in, AppColors.primaryBlue),
                    _buildKpiCard('Average Score', '88.5%', Icons.analytics, AppColors.secondaryOrange),
                  ],
                ),
                
                const SizedBox(height: 32),

                // Report Card Generation Area
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Comprehensive Report Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.print),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connecting to cloud printer...')));
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildReportRow('Mathematics', 'Grade: A+ | Score: 95/100'),
                      _buildReportRow('Science & Biology', 'Grade: A | Score: 88/100'),
                      _buildReportRow('English Grammar', 'Grade: B+ | Score: 78/100'),
                      _buildReportRow('Computer Science', 'Grade: A+ | Score: 98/100'),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Download Report Card PDF',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading report card PDF...')));
                        },
                      )
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),

                // Certificates system
                const Text('Certificates & Banners', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: acadProvider.certificates.length,
                  itemBuilder: (context, index) {
                    final cert = acadProvider.certificates[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.secondaryOrange.withOpacity(0.4), width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColors.secondaryOrange.withOpacity(0.12),
                              child: const Icon(Icons.workspace_premium, color: AppColors.secondaryOrange, size: 36),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cert['title']!, style: const TextStyle(fontWeight: FontWeight.extrabold, fontSize: 15)),
                                  const SizedBox(height: 4),
                                  Text(cert['description']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Text('Issued: ${cert['date']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.file_download_outlined, color: AppColors.primaryBlue),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading certificate file...')));
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.extrabold)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportRow(String subject, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(details, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryBlue, fontSize: 13)),
        ],
      ),
    );
  }
}
