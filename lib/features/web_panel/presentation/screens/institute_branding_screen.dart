import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/services/enterprise_provider.dart';

class InstituteBrandingScreen extends StatefulWidget {
  const InstituteBrandingScreen({super.key});

  @override
  State<InstituteBrandingScreen> createState() => _InstituteBrandingScreenState();
}

class _InstituteBrandingScreenState extends State<InstituteBrandingScreen> {
  final _primaryColorController = TextEditingController(text: '1E3C72');
  final _secondaryColorController = TextEditingController(text: 'FF5E36');
  final _schoolNameController = TextEditingController(text: 'Agarwal Knowledge Hub');
  final _emailController = TextEditingController(text: 'info@agarwal.com');
  final _whatsappPhoneController = TextEditingController(text: '+919876543210');

  bool _enableEmailAlerts = true;
  bool _enableWhatsappAlerts = true;

  @override
  void dispose() {
    _primaryColorController.dispose();
    _secondaryColorController.dispose();
    _schoolNameController.dispose();
    _emailController.dispose();
    _whatsappPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entProvider = Provider.of<EnterpriseProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Branding & Customizations Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Branding override card
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Theme Colors overrides', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text(
                        'Change primary theme colors for Splash, buttons, and app headers.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const Divider(height: 32),
                      
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _primaryColorController,
                              labelText: 'Primary Color (Hex)',
                              hintText: 'e.g. 1E3C72',
                              prefixIcon: Icons.color_lens_outlined,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: _secondaryColorController,
                              labelText: 'Secondary Color (Hex)',
                              hintText: 'e.g. FF5E36',
                              prefixIcon: Icons.color_lens_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        controller: _schoolNameController,
                        labelText: 'Institute Display Name',
                        hintText: 'Agarwal Knowledge Hub',
                        prefixIcon: Icons.school_outlined,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),

                // Automation Alerts Card
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Communication Automations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(height: 32),
                      
                      SwitchListTile(
                        title: const Text('Email Automations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: const Text('Auto-dispatch welcome email, results report to parents, and exam notices.'),
                        value: _enableEmailAlerts,
                        onChanged: (val) {
                          setState(() {
                            _enableEmailAlerts = val;
                          });
                        },
                      ),
                      if (_enableEmailAlerts)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                          child: CustomTextField(
                            controller: _emailController,
                            labelText: 'Sender Email Address',
                            hintText: 'alerts@dav.edu.in',
                            prefixIcon: Icons.mail_outline,
                          ),
                        ),
                        
                      SwitchListTile(
                        title: const Text('WhatsApp Alerts via API', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: const Text('Deliver instant updates for low attendance and missing homework tasks.'),
                        value: _enableWhatsappAlerts,
                        onChanged: (val) {
                          setState(() {
                            _enableWhatsappAlerts = val;
                          });
                        },
                      ),
                      if (_enableWhatsappAlerts)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                          child: CustomTextField(
                            controller: _whatsappPhoneController,
                            labelText: 'WhatsApp Business Number',
                            hintText: '+919876543210',
                            prefixIcon: Icons.phone_outlined,
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                CustomButton(
                  text: 'Save Identity Changes',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Custom branding & automations profile saved.')),
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
