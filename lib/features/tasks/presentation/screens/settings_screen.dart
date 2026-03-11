import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/app_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const AppText.title('Settings')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserSessionCard(onLogout: onLogout),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserSessionCard extends StatelessWidget {
  const UserSessionCard({
    super.key,
    required this.onLogout,
  });

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title('Account'),
          SizedBox(height: 8.h),
          const AppText.medium('Manage your session from here.'),
          SizedBox(height: 20.h),
          AppButton(
            label: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            variant: AppButtonVariant.destructive,
            onPressed: () async {
              final shouldLogout = await showAppConfirmationDialog(
                context,
                title: 'Logout?',
                message:
                    'You will be signed out of your account on this device.',
                confirmLabel: 'Logout',
                isDestructive: true,
              );
    
              if (!shouldLogout || !context.mounted) {
                return;
              }
    
              Navigator.of(context).pop();
              onLogout();
            },
          ),
        ],
      ),
    );
  }
}
