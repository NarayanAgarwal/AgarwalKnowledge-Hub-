import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/services/enterprise_provider.dart';
import '../../../../core/models/institute.dart';

class SuperAdminMasterPanel extends StatefulWidget {
  const SuperAdminMasterPanel({super.key});

  @override
  State<SuperAdminMasterPanel> createState() => _SuperAdminMasterPanelState();
}

class _SuperAdminMasterPanelState extends State<SuperAdminMasterPanel> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onCreateInstitute(EnterpriseProvider provider) {
    if (_nameController.text.trim().isEmpty) return;

    final inst = Institute(
      id: 'inst_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      logoUrl: '',
      primaryColorHex: '1E3C72',
      secondaryColorHex: 'FF5E36',
      contactEmail: _emailController.text.trim(),
      contactPhone: _phoneController.text.trim(),
      featureFlags: {
        'Homework': true,
        'Quiz': true,
        'Stories': true,
        'AI Assistant': true,
      },
    );

    provider.createInstitute(inst);

    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Enterprise institute tenant initialized.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entProvider = Provider.of<EnterpriseProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Master Control'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: active institutes list & logs
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Institutes & Schools', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Card(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entProvider.institutes.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final inst = entProvider.institutes[index];
                        final bool isSuspended = inst.status == 'Suspended';

                        return ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.school)),
                          title: Text(inst.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Email: ${inst.contactEmail} | Phone: ${inst.contactPhone}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                inst.status,
                                style: TextStyle(
                                  color: isSuspended ? AppColors.error : AppColors.accentGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              PopupMenuButton<String>(
                                onSelected: (val) {
                                  if (val == 'suspend') {
                                    entProvider.suspendInstitute(inst.id);
                                  } else if (val == 'activate') {
                                    entProvider.activateInstitute(inst.id);
                                  } else if (val == 'delete') {
                                    entProvider.deleteInstitute(inst.id);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(value: isSuspended ? 'activate' : 'suspend', child: Text(isSuspended ? 'Activate' : 'Suspend')),
                                  const PopupMenuItem(value: 'delete', child: Text('Delete Tenant')),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  const Text('System Audit Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Card(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entProvider.auditLogs.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final log = entProvider.auditLogs[index];
                        return ListTile(
                          leading: const Icon(Icons.history, color: Colors.grey),
                          title: Text(log.description, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          subtitle: Text('By: ${log.operatorName} (${log.operatorRole}) | ${log.timestamp.toString().substring(11, 16)}'),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          
          // Right: Create new Institute form
          Container(
            width: 360,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border(
                left: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Provision New Institute', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Institute Name',
                  hintText: 'e.g. DAV Public School Patna',
                  prefixIcon: Icons.school_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Contact Email',
                  hintText: 'contact@dav.edu.in',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'Contact Phone',
                  hintText: '+919876543220',
                  prefixIcon: Icons.phone_android_outlined,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Create Institute',
                  onPressed: () => _onCreateInstitute(entProvider),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
