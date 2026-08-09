import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import 'class_details_screen.dart';

class ClassSelectionScreen extends StatelessWidget {
  const ClassSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Academic Classes'),
          bottom: TabBar(
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.secondaryOrange,
            tabs: const [
              Tab(text: 'CBSE (English)'),
              Tab(text: 'BSEB (Hindi)'),
              Tab(text: 'Computer Science'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCbseTab(context, isDark),
            _buildBsebTab(context, isDark),
            _buildComputerTab(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildCbseTab(BuildContext context, bool isDark) {
    final cbseClasses = [
      'Nursery',
      'LKG',
      'UKG',
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
    ];
    return _buildClassGrid(context, cbseClasses, 'CBSE English Medium', isDark);
  }

  Widget _buildBsebTab(BuildContext context, bool isDark) {
    final bsebClasses = [
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
    ];
    return _buildClassGrid(context, bsebClasses, 'BSEB Hindi Medium', isDark);
  }

  Widget _buildComputerTab(BuildContext context, bool isDark) {
    final computerCourses = [
      'Computer Theory',
      'Computer Practical',
    ];
    return _buildClassGrid(context, computerCourses, 'Computer Education', isDark);
  }

  Widget _buildClassGrid(BuildContext context, List<String> items, String category, bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final className = items[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassDetailsScreen(
                  className: className,
                  category: category,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: -15,
                  right: -15,
                  child: Icon(
                    Icons.school,
                    size: 80,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.menu_book, color: Colors.white, size: 18),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            className,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            category,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ).animate(delay: (index * 40).ms).fade(duration: 250.ms).slideY(begin: 0.1, end: 0.0),
        );
      },
    );
  }
}
