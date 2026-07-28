import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../dashboard/viewmodels/dashboard_viewmodel.dart';

class HomeworkScreen extends StatelessWidget {
  const HomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashVm = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      body: dashVm.homeworkList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No homework assigned yet.'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dashVm.homeworkList.length,
              itemBuilder: (context, index) {
                final hw = dashVm.homeworkList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFFFEFEA),
                      child: Icon(Icons.assignment_outlined, color: AppColors.secondaryOrange),
                    ),
                    title: Text(hw.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hw.description),
                        const SizedBox(height: 4),
                        Text('Deadline: ${hw.deadline.day}/${hw.deadline.month}/${hw.deadline.year}',
                            style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  ),
                );
              },
            ),
    );
  }
}
