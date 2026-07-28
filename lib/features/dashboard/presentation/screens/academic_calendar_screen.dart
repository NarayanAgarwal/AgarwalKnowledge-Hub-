import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';

class AcademicCalendarScreen extends StatelessWidget {
  const AcademicCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Calendar event list
    final events = [
      {'title': 'Science Fair Preparation Day', 'type': 'Holiday / Event', 'date': 'July 28, 2026', 'color': AppColors.accentGreen},
      {'title': 'Computer Midterm Exam', 'type': 'Exam Session', 'date': 'August 02, 2026', 'color': AppColors.primaryBlue},
      {'title': 'Math Chapter 2 fractions Homework due', 'type': 'Assignment Due', 'date': 'July 30, 2026', 'color': AppColors.secondaryOrange},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Calendar & reminders'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Displaying simulated calendar view
                GlassContainer(
                  child: Column(
                    children: [
                      const Text(
                        'July - August 2026',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 7,
                        children: List.generate(31, (index) {
                          final day = index + 1;
                          final bool isToday = day == 26; // Simulated current day July 26
                          
                          return Center(
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isToday ? AppColors.secondaryOrange : Colors.transparent,
                                border: isToday ? Border.all(color: Colors.white, width: 2) : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                  color: isToday ? Colors.white : null,
                                ),
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                const Text('Upcoming Schedules & Reminders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final ev = events[index];
                    final Color color = ev['color'] as Color;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withOpacity(0.12),
                          child: Icon(Icons.circle, color: color, size: 12),
                        ),
                        title: Text(ev['title']! as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(ev['type']! as String),
                        trailing: Text(ev['date']! as String, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
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
}
