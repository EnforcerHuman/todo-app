import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/task_entity.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({required this.task, super.key});

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accentColor = task.isCompleted
        ? const Color(0xFF16A34A)
        : const Color(0xFF155EEF);
    final localizations = MaterialLocalizations.of(context);
    final createdDate = localizations.formatFullDate(task.createdAt);
    final createdTime = TimeOfDay.fromDateTime(task.createdAt).format(context);
    final updatedDate = localizations.formatFullDate(task.updatedAt);
    final updatedTime = TimeOfDay.fromDateTime(task.updatedAt).format(context);

    return Scaffold(
      appBar: AppBar(title: const AppText.title('Task details')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: ListView(
                children: [
                  // Task details including title, description and status
                  TaskDetailsSection(accentColor: accentColor, task: task, colors: colors),
                  //basic spacing between the details and timeline sections
                  SizedBox(height: 16.h),
                  //shows the timeline of the task with created and updated timestamps
                  TimeLineSection(createdDate: createdDate, createdTime: createdTime, updatedDate: updatedDate, updatedTime: updatedTime),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TimeLineSection extends StatelessWidget {
  const TimeLineSection({
    super.key,
    required this.createdDate,
    required this.createdTime,
    required this.updatedDate,
    required this.updatedTime,
  });

  final String createdDate;
  final String createdTime;
  final String updatedDate;
  final String updatedTime;

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      title: 'Timeline',
      children: [
        _DetailRow(
          label: 'Created',
          value: '$createdDate at $createdTime',
        ),
        SizedBox(height: 12.h),
        _DetailRow(
          label: 'Updated',
          value: '$updatedDate at $updatedTime',
        ),
      ],
    );
  }
}

class TaskDetailsSection extends StatelessWidget {
  const TaskDetailsSection({
    super.key,
    required this.accentColor,
    required this.task,
    required this.colors,
  });

  final Color accentColor;
  final TaskEntity task;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: AppText(
              task.isCompleted ? 'Completed' : 'In progress',
              color: accentColor,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 16.h),
          AppText(
            task.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 12.h),
          AppText.medium(
            task.description.trim().isEmpty
                ? 'No description added for this task.'
                : task.description,
            color: colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title(title),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.small(
          label,
          color: const Color(0xFF667085),
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 4.h),
        AppText.medium(value),
      ],
    );
  }
}
