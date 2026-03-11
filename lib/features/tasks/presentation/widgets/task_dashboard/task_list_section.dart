import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/task_entity.dart';
import '../common/app_section_card.dart';
import 'task_tile.dart';

class TaskListSection extends StatefulWidget {
  const TaskListSection({
    required this.isCompact,
    required this.isLoading,
    required this.isSubmitting,
    required this.tasks,
    required this.onRefresh,
    required this.onCreate,
    required this.onDelete,
    required this.onEdit,
    required this.onToggle,
    super.key,
  });

  final bool isCompact;
  final bool isLoading;
  final bool isSubmitting;
  final List<TaskEntity> tasks;
  final VoidCallback onRefresh;
  final VoidCallback onCreate;
  final ValueChanged<String> onDelete;
  final ValueChanged<TaskEntity> onEdit;
  final void Function(TaskEntity task, bool value) onToggle;

  @override
  State<TaskListSection> createState() => _TaskListSectionState();
}

class _TaskListSectionState extends State<TaskListSection> {
  _TaskFilter _filter = _TaskFilter.all;

  @override
  Widget build(BuildContext context) {
    final completedCount = widget.tasks
        .where((task) => task.isCompleted)
        .length;
    final activeCount = widget.tasks.length - completedCount;
    final filteredTasks = switch (_filter) {
      _TaskFilter.all => widget.tasks,
      _TaskFilter.active =>
        widget.tasks.where((task) => !task.isCompleted).toList(),
      _TaskFilter.completed =>
        widget.tasks.where((task) => task.isCompleted).toList(),
    };

    return AppSectionCard(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _TaskListHeader(
              totalCount: widget.tasks.length,
              activeCount: activeCount,
              completedCount: completedCount,
              currentFilter: _filter,
              isSubmitting: widget.isSubmitting,
              onRefresh: widget.onRefresh,
              onFilterChanged: (filter) => setState(() => _filter = filter),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
            sliver: _TaskListContent(
              isLoading: widget.isLoading,
              filteredTasks: filteredTasks,
              onCreate: widget.onCreate,
              onDelete: widget.onDelete,
              onEdit: widget.onEdit,
              onToggle: widget.onToggle,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskListHeader extends StatelessWidget {
  const _TaskListHeader({
    required this.totalCount,
    required this.activeCount,
    required this.completedCount,
    required this.currentFilter,
    required this.isSubmitting,
    required this.onRefresh,
    required this.onFilterChanged,
  });

  final int totalCount;
  final int activeCount;
  final int completedCount;
  final _TaskFilter currentFilter;
  final bool isSubmitting;
  final VoidCallback onRefresh;
  final ValueChanged<_TaskFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 12.h,
          spacing: 12.w,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 680.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s list',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Keep the list short, clear, and easy to finish.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              _FilterChip(
                label: 'All',
                count: totalCount,
                selected: currentFilter == _TaskFilter.all,
                onTap: () => onFilterChanged(_TaskFilter.all),
              ),
              _FilterChip(
                label: 'Active',
                count: activeCount,
                selected: currentFilter == _TaskFilter.active,
                onTap: () => onFilterChanged(_TaskFilter.active),
              ),
              _FilterChip(
                label: 'Done',
                count: completedCount,
                selected: currentFilter == _TaskFilter.completed,
                onTap: () => onFilterChanged(_TaskFilter.completed),
              ),
              if (isSubmitting)
                Padding(
                  padding: EdgeInsets.only(left: 4.w, top: 10.h),
                  child: SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TaskListContent extends StatelessWidget {
  const _TaskListContent({
    required this.isLoading,
    required this.filteredTasks,
    required this.onCreate,
    required this.onDelete,
    required this.onEdit,
    required this.onToggle,
  });

  final bool isLoading;
  final List<TaskEntity> filteredTasks;
  final VoidCallback onCreate;
  final ValueChanged<String> onDelete;
  final ValueChanged<TaskEntity> onEdit;
  final void Function(TaskEntity task, bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (filteredTasks.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(onCreate: onCreate),
      );
    }

    return SliverList.separated(
      itemCount: filteredTasks.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return TaskTile(
          task: task,
          onDelete: () => onDelete(task.id),
          onEdit: () => onEdit(task),
          onToggle: (value) => onToggle(task, value),
        );
      },
    );
  }
}

enum _TaskFilter { all, active, completed }

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = selected
        ? const Color(0xFF111827)
        : const Color(0xFFF3F4F6);
    final foreground = selected ? Colors.white : const Color(0xFF111827);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.18)
                    : Colors.white,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: foreground,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.task_alt_rounded, size: 54.sp),
          SizedBox(height: 16.h),
          Text('No tasks yet', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8.h),
          const Text('Add your first task to start tracking work.'),
          SizedBox(height: 16.h),
          ElevatedButton(onPressed: onCreate, child: const Text('Create task')),
        ],
      ),
    );
  }
}
