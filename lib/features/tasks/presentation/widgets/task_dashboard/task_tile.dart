import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/app_text.dart';
import '../../../domain/entities/task_entity.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    this.isProcessing = false,
    this.isToggling = false,
    required this.onDelete,
    required this.onEdit,
    required this.onToggle,
    super.key,
  });

  final TaskEntity task;
  final bool isProcessing;
  final bool isToggling;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final formatter = TimeOfDay.fromDateTime(task.updatedAt).format(context);
    final accentColor = task.isCompleted
        ? const Color(0xFF16A34A)
        : const Color(0xFF155EEF);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compactLayout = constraints.maxWidth < 460;

        final isBusy = isProcessing || isToggling;

        return Stack(
          children: [
            AbsorbPointer(
              absorbing: isBusy,
              child: Opacity(
                opacity: isProcessing ? 0.45 : 1,
                child: Container(
                  padding: EdgeInsets.all(compactLayout ? 14.w : 18.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(color: const Color(0xFFEAECF0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF101828).withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 10.w,
                            height: compactLayout ? 40.h : 46.h,
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: AppText.title(
                                task.title,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      fontSize: compactLayout ? 18.sp : null,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          isToggling
                              ? SizedBox(
                                  width: compactLayout ? 36.w : 40.w,
                                  height: compactLayout ? 36.w : 40.w,
                                  child: Center(
                                    child: SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: accentColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Checkbox(
                                  value: task.isCompleted,
                                  visualDensity: compactLayout
                                      ? VisualDensity.compact
                                      : VisualDensity.standard,
                                  onChanged: (value) =>
                                      onToggle(value ?? false),
                                  activeColor: accentColor,
                                ),
                        ],
                      ),
                      if (task.description.trim().isNotEmpty) ...[
                        SizedBox(height: 6.h),
                        Padding(
                          padding: EdgeInsets.only(left: 22.w),
                          child: AppText(
                            task.description,
                            maxLines: compactLayout ? 3 : null,
                            overflow: compactLayout
                                ? TextOverflow.ellipsis
                                : null,
                          ),
                        ),
                      ],
                      SizedBox(height: 14.h),
                      Wrap(
                        runSpacing: 10.h,
                        spacing: 10.w,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _InfoPill(
                            label: task.isCompleted
                                ? 'Completed'
                                : 'In progress',
                            color: accentColor,
                            icon: task.isCompleted
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_checked_rounded,
                          ),
                          _InfoPill(
                            label: 'Updated $formatter',
                            color: const Color(0xFF111827),
                            icon: Icons.schedule_rounded,
                            subtle: true,
                          ),
                          Wrap(
                            spacing: 8.w,
                            children: [
                              _ActionButton(
                                icon: Icons.edit_outlined,
                                onTap: onEdit,
                              ),
                              _ActionButton(
                                icon: Icons.delete_outline_rounded,
                                onTap: onDelete,
                                destructive: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isProcessing)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.color,
    required this.icon,
    this.subtle = false,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: subtle ? const Color(0xFFF3F4F6) : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 8.w),
          AppText(
            label,
            color: color,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? const Color(0xFFDC2626)
        : const Color(0xFF111827);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Ink(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: destructive
              ? const Color(0xFFFEF2F2)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(icon, size: 20.sp, color: color),
      ),
    );
  }
}
