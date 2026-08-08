import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _launchUrl(String url) {
    try {
      html.window.open(url, '_blank');
    } catch (e) {
      debugPrint("Could not open URL: $e");
    }
  }

  void _showShareDialog(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Share App',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Method 1: QR Code
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Image.network(
                      'https://api.qrserver.com/v1/create-qr-code/?size=180x180&color=050e2e&data=https://agarwalknowledgehub.vercel.app',
                      height: 180,
                      width: 180,
                      errorBuilder: (context, error, stackTrace) => const SizedBox(
                        height: 180,
                        child: Center(
                          child: Icon(Icons.qr_code, size: 64, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Method 1: Scan QR Code',
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const Text(
                      'Scan this QR code to download & install instantly',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Method 2: Shareable Link
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.link, size: 18, color: AppColors.primaryBlue),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'agarwalknowledgehub.vercel.app',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16),
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(text: 'https://agarwalknowledgehub.vercel.app'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('App link copied to clipboard! 📋')),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Method 3: Direct WhatsApp Invite Share
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  final text = Uri.encodeComponent(
                    'Hey! Join Agarwal Knowledge Hub to access online classes, homework, quizzes, and resources. Download and install the app here: https://agarwalknowledgehub.vercel.app'
                  );
                  _launchUrl('https://wa.me/?text=$text');
                },
                icon: const Icon(Icons.share, size: 16),
                label: const Text('Method 3: Share on WhatsApp', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

          // App Share Option Card
          Card(
            child: ListTile(
              leading: const Icon(Icons.share_outlined, color: AppColors.secondaryOrange),
              title: const Text('Share App with Friends', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Share download links, QR codes, and WhatsApp invites'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                _showShareDialog(context);
              },
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
