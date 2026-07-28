import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'custom_button.dart';

class ErrorScreen extends StatelessWidget {
  final String errorType; // 'internet' | 'auth' | 'timeout' | 'permission' | 'unknown'
  final String message;
  final VoidCallback onRetry;

  const ErrorScreen({
    super.key,
    required this.errorType,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;
    
    switch (errorType) {
      case 'internet':
        icon = Icons.wifi_off_outlined;
        title = 'Network Connection Offline';
        break;
      case 'auth':
        icon = Icons.gpp_bad_outlined;
        title = 'Authentication Error';
        break;
      case 'timeout':
        icon = Icons.timer_off_outlined;
        title = 'Request Timeout';
        break;
      case 'permission':
        icon = Icons.no_accounts_outlined;
        title = 'Permission Denied';
        break;
      default:
        icon = Icons.error_outline;
        title = 'Unexpected Error';
        break;
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.error.withOpacity(0.12),
                  child: Icon(icon, color: AppColors.error, size: 48),
                ),
                const SizedBox(height: 32),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 48),
                CustomButton(
                  text: 'Retry Operation',
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
