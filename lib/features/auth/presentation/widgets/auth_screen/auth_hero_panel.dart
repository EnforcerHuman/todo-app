import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/app_text.dart';
import '../../blocs/auth_form/auth_form_bloc.dart';

class AuthHeroPanel extends StatelessWidget {
  const AuthHeroPanel({required this.mode, super.key});

  final AuthFormMode mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF155EEF), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: const AppText(
              'Clean Architecture + BLoC',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 48.h),
          AppText(
            mode == AuthFormMode.signIn
                ? 'Plan tasks with a faster daily flow.'
                : 'Create an account and start managing tasks.',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              height: 1.1,
            ),
          ),
          SizedBox(height: 16.h),
          AppText.large(
            'Authentication is powered by Firebase Auth. '
            'Tasks are stored in Firebase Realtime Database through REST calls.',
            color: Colors.white.withValues(alpha: 0.88),
          ),
          SizedBox(height: 32.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: const [
              _HighlightChip(label: 'Responsive layout'),
              _HighlightChip(label: 'Task status tracking'),
              _HighlightChip(label: 'Realtime Database'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HighlightChip extends StatelessWidget {
  const _HighlightChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: AppText(
        label,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 13.sp,
      ),
    );
  }
}
