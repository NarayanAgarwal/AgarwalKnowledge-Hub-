import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/services/enterprise_provider.dart';

class EnterpriseSettingsPanel extends StatelessWidget {
  const EnterpriseSettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final entProvider = Provider.of<EnterpriseProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enterprise Portal Control Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language switcher card
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('System Language / भाषा', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ChoiceChip(
                            label: const Text('English (US)'),
                            selected: entProvider.currentLanguage == 'en',
                            onSelected: (val) {
                              if (val) entProvider.switchLanguage('en');
                            },
                          ),
                          ChoiceChip(
                            label: const Text('हिन्दी (Hindi)'),
                            selected: entProvider.currentLanguage == 'hi',
                            onSelected: (val) {
                              if (val) entProvider.switchLanguage('hi');
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),

                // Feature Flags toggles
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Modular Feature Flags (No Code Changes)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text(
                        'Instantly toggle modules on/off for students and teachers across the platform.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const Divider(height: 32),
                      
                      _buildFlagTile(entProvider, 'Homework', 'Enable homework submissions upload.'),
                      _buildFlagTile(entProvider, 'Quiz', 'Enable classroom test play engines.'),
                      _buildFlagTile(entProvider, 'Stories', 'Enable classroom uploader slides.'),
                      _buildFlagTile(entProvider, 'AI Assistant', 'Enable automated student doubts reply helper.'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),

                // Backup & Restore settings
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cloud Storage Backup Registry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Last Backup: Completed Today', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.cloud_upload),
                            label: const Text('Backup Now'),
                            onPressed: () {
                              entProvider.triggerManualBackup();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Manual backup snapshot initiated...')),
                              );
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Backup Snapshots History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: entProvider.backupHistory.length,
                        itemBuilder: (context, index) {
                          final bak = entProvider.backupHistory[index];
                          return ListTile(
                            leading: const Icon(Icons.backup_outlined),
                            title: Text('${bak['type']} (${bak['size']})'),
                            subtitle: Text('Date: ${bak['date']}'),
                            trailing: TextButton(
                              onPressed: () {
                                entProvider.restoreBackup(bak['id']!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Restoring backup snapshot...')),
                                );
                              },
                              child: const Text('Restore'),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlagTile(EnterpriseProvider provider, String feature, String desc) {
    final bool isEnabled = provider.isFeatureEnabled(feature);
    return SwitchListTile(
      title: Text(feature, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
      value: isEnabled,
      onChanged: (val) {
        provider.toggleFeatureFlag(feature, val);
      },
    );
  }
}
