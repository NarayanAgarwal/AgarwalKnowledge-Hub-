import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsVm = Provider.of<SettingsViewModel>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Toggler
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Enable low-light dark interface theme'),
              secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primaryBlue),
              value: themeProvider.isDarkMode,
              onChanged: (val) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          
          const SizedBox(height: 12),

          // Notifications Switcher
          Card(
            child: SwitchListTile(
              title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Receive push alerts for homework & notices'),
              secondary: const Icon(Icons.notifications_outlined, color: AppColors.primaryBlue),
              value: settingsVm.notificationsEnabled,
              onChanged: (val) {
                settingsVm.toggleNotifications(val);
              },
            ),
          ),

          const SizedBox(height: 12),

          // Language Selector
          Card(
            child: ListTile(
              leading: const Icon(Icons.translate_outlined, color: AppColors.primaryBlue),
              title: const Text('Language Preference', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(settingsVm.language),
              trailing: DropdownButton<String>(
                value: settingsVm.language,
                underline: const SizedBox.shrink(),
                icon: const Icon(Icons.arrow_drop_down),
                items: ['English', 'Hindi'].map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang,
                    child: Text(lang),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    settingsVm.changeLanguage(val);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Mock General Settings Links
          _buildLinksCard(context, isDark),
        ],
      ),
    );
  }

  Widget _buildLinksCard(BuildContext context, bool isDark) {
    return Card(
      child: Column(
        children: [
          _buildSettingsLink(
            icon: Icons.info_outline,
            title: 'About Agarwal Knowledge Hub',
            onTap: () => _showDialog(context, 'About', 'Agarwal Knowledge Hub is a premium modern Education Management System supporting CBSE English Medium, BSEB Hindi Medium, and computer courses.'),
          ),
          const Divider(height: 1),
          _buildSettingsLink(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _showDialog(context, 'Privacy Policy', 'Your personal details are stored securely. Role-based access protects student files from unauthorized write access.'),
          ),
          const Divider(height: 1),
          _buildSettingsLink(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () => _showDialog(context, 'Help Center', 'For admission inquiries or portal errors, contact your administrator at help@agarwal.com.'),
          ),
          const Divider(height: 1),
          _buildSettingsLink(
            icon: Icons.feedback_outlined,
            title: 'Submit Feedback',
            onTap: () => _showDialog(context, 'Feedback', 'Thank you for choosing Agarwal Knowledge Hub. Please mail your suggestions to feedback@agarwal.com.'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsLink({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
