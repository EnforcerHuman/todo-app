import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/task_entity.dart';
import '../common/app_section_card.dart';

class TaskOverviewPanel extends StatelessWidget {
  const TaskOverviewPanel({
    required this.tasks,
    required this.isCompact,
    super.key,
  });

  final List<TaskEntity> tasks;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final total = tasks.length;
    final completed = tasks.where((task) => task.isCompleted).length;
    final active = total - completed;
    final completionRate = total == 0 ? 0.0 : completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 14.h,
            children: [
              Text('Analyze', style: Theme.of(context).textTheme.titleLarge),
              Text(
                active == 0
                    ? 'Everything is completed. This is a good moment to plan what comes next.'
                    : '$active ${active == 1 ? 'task remains' : 'tasks remain'} open. Clearing even one will make the list feel lighter.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: const Color(0xFFEAECF0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        active == 0
                            ? Icons.check_circle_rounded
                            : Icons.insights_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        active == 0
                            ? 'Strong finish. Keep the next set of tasks short and intentional.'
                            : 'Best next move: finish one active task before adding a new one.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        AppSectionCard(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 720
                  ? 3
                  : constraints.maxWidth >= 420
                  ? 2
                  : 1;
              final spacing = 8.w;
              final itemWidth =
                  (constraints.maxWidth - (spacing * (columns - 1))) / columns;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'A compact snapshot of what is done and what still needs attention.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 14.h),
                  Wrap(
                    spacing: spacing,
                    runSpacing: 8.h,
                    children: [
                      _OverviewMetricCard(
                        width: itemWidth,
                        label: 'Total',
                        value: '$total',
                        color: const Color(0xFF155EEF),
                      ),
                      _OverviewMetricCard(
                        width: itemWidth,
                        label: 'Active',
                        value: '$active',
                        color: const Color(0xFFF97316),
                      ),
                      _OverviewMetricCard(
                        width: itemWidth,
                        label: 'Done',
                        value: '$completed',
                        color: const Color(0xFF16A34A),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFEAECF0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Completion rate',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            Text(
                              '${(completionRate * 100).round()}%',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(fontSize: 18.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999.r),
                          child: LinearProgressIndicator(
                            value: completionRate,
                            minHeight: 8.h,
                            backgroundColor: const Color(0xFFE5E7EB),
                            color: const Color(0xFF155EEF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OverviewMetricCard extends StatelessWidget {
  const _OverviewMetricCard({
    required this.width,
    required this.label,
    required this.value,
    required this.color,
  });

  final double width;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color, radius: 6.r),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
