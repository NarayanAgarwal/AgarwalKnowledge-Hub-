import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../dashboard/viewmodels/dashboard_viewmodel.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashVm = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      body: dashVm.notices.isEmpty
          ? const Center(child: Text('No notices published.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dashVm.notices.length,
              itemBuilder: (context, index) {
                final notice = dashVm.notices[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: notice.type == 'Urgent'
                        ? AppColors.error.withOpacity(0.05)
                        : AppColors.primaryBlue.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: notice.type == 'Urgent'
                          ? AppColors.error.withOpacity(0.2)
                          : AppColors.primaryBlue.withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(notice.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                      Text(notice.content, style: const TextStyle(height: 1.4)),
                      const SizedBox(height: 12),
                      Text(
                        'Published on: ${notice.createdDate.day}/${notice.createdDate.month}/${notice.createdDate.year} by ${notice.sender}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
