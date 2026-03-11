import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/app_text.dart';
import '../../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../../domain/entities/task_entity.dart';

class TaskHeader extends StatelessWidget {
  const TaskHeader({
    required this.tasks,
    required this.onCreate,
    required this.onOpenSettings,
    required this.isCompact,
    super.key,
  });

  final List<TaskEntity> tasks;
  final VoidCallback onCreate;
  final VoidCallback onOpenSettings;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    final completed = tasks.where((task) => task.isCompleted).length;
    final active = tasks.length - completed;
    final displayName = user?.name?.trim();
    final name = displayName != null && displayName.isNotEmpty
        ? displayName
        : (user?.email.split('@').first ?? 'there');
    final subtitle = active == 0
        ? 'A quiet board, a clear mind. Start something worth finishing.'
        : 'You are $active step${active == 1 ? '' : 's'} away from a cleaner day.';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 18.w : 22.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF155EEF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF155EEF).withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wb_sunny_rounded,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    AppText(
                      active == 0 ? 'All caught up' : '$active active today',
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      style: const TextStyle(letterSpacing: 0.2),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton.filledTonal(
                onPressed: onOpenSettings,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 16.w : 18.w,
              vertical: isCompact ? 16.h : 18.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Hello, $name',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    height: 1.02,
                    fontSize: isCompact ? 28.sp : 34.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 10.h),
                AppText.large(
                  subtitle,
                  color: Colors.white.withValues(alpha: 0.84),
                  fontSize: isCompact ? 14.sp : 15.sp,
                  style: const TextStyle(height: 1.45),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          AppText.medium(
            user?.email ?? '',
            color: Colors.white.withValues(alpha: 0.64),
            style: const TextStyle(letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }
}
