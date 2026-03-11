import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../blocs/task/task_bloc.dart';
import '../../../domain/entities/task_entity.dart';
import '../common/app_section_card.dart';
import 'task_tile.dart';

class TaskListSection extends StatefulWidget {
  const TaskListSection({
    required this.isCompact,
    required this.isLoading,
    required this.isSubmitting,
    required this.activeMutation,
    required this.activeTaskId,
    required this.tasks,
    required this.onRefresh,
    required this.onCreate,
    required this.onDelete,
    required this.onEdit,
    required this.onOpen,
    required this.onToggle,
    super.key,
  });

  final bool isCompact;
  final bool isLoading;
  final bool isSubmitting;
  final TaskMutationType activeMutation;
  final String? activeTaskId;
  final List<TaskEntity> tasks;
  final VoidCallback onRefresh;
  final VoidCallback onCreate;
  final ValueChanged<String> onDelete;
  final ValueChanged<TaskEntity> onEdit;
  final ValueChanged<TaskEntity> onOpen;
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
              isSubmitting: widget.isSubmitting,
              activeMutation: widget.activeMutation,
              activeTaskId: widget.activeTaskId,
              onDelete: widget.onDelete,
              onEdit: widget.onEdit,
              onOpen: widget.onOpen,
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
    required this.onRefresh,
    required this.onFilterChanged,
  });

  final int totalCount;
  final int activeCount;
  final int completedCount;
  final _TaskFilter currentFilter;
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
                  const AppText.title('Task\'s list'),
                  SizedBox(height: 6.h),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText.medium(
                        'Keep the list short, clear, and easy to finish.',
                      ),
                       AppText.medium(
                        color: Color.fromARGB(241, 3, 3, 185),
                        '***Tap on a task to view details***',
                        
                      ),
                    ],
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
    required this.isSubmitting,
    required this.activeMutation,
    required this.activeTaskId,
    required this.onDelete,
    required this.onEdit,
    required this.onOpen,
    required this.onToggle,
  });

  final bool isLoading;
  final List<TaskEntity> filteredTasks;
  final VoidCallback onCreate;
  final bool isSubmitting;
  final TaskMutationType activeMutation;
  final String? activeTaskId;
  final ValueChanged<String> onDelete;
  final ValueChanged<TaskEntity> onEdit;
  final ValueChanged<TaskEntity> onOpen;
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

    final sectionItems = _buildSectionItems(filteredTasks);

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = sectionItems[index];

        if (item is _TaskSectionHeaderItem) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h, top: index == 0 ? 0 : 12.h),
            child: AppText.title(item.label, fontSize: 18.sp),
          );
        }

        final task = (item as _TaskSectionTaskItem).task;
        final isProcessingTask =
            isSubmitting &&
            activeTaskId == task.id &&
            (activeMutation == TaskMutationType.update ||
                activeMutation == TaskMutationType.delete);
        final isTogglingTask =
            isSubmitting &&
            activeTaskId == task.id &&
            activeMutation == TaskMutationType.toggle;

        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: TaskTile(
            task: task,
            isProcessing: isProcessingTask,
            isToggling: isTogglingTask,
            onOpen: () => onOpen(task),
            onDelete: () => onDelete(task.id),
            onEdit: () => onEdit(task),
            onToggle: (value) => onToggle(task, value),
          ),
        );
      }, childCount: sectionItems.length),
    );
  }

  List<_TaskSectionItem> _buildSectionItems(List<TaskEntity> tasks) {
    final now = DateTime.now();
    final todayTasks = <TaskEntity>[];
    final previousTasks = <TaskEntity>[];

    for (final task in tasks) {
      if (_isSameDay(task.createdAt, now)) {
        todayTasks.add(task);
      } else {
        previousTasks.add(task);
      }
    }

    final items = <_TaskSectionItem>[];

    if (todayTasks.isNotEmpty) {
      items
        ..add(const _TaskSectionHeaderItem('Today'))
        ..addAll(todayTasks.map(_TaskSectionTaskItem.new));
    }

    if (previousTasks.isNotEmpty) {
      items
        ..add(const _TaskSectionHeaderItem('Previous'))
        ..addAll(previousTasks.map(_TaskSectionTaskItem.new));
    }

    return items;
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}

sealed class _TaskSectionItem {
  const _TaskSectionItem();
}

class _TaskSectionHeaderItem extends _TaskSectionItem {
  const _TaskSectionHeaderItem(this.label);

  final String label;
}

class _TaskSectionTaskItem extends _TaskSectionItem {
  const _TaskSectionTaskItem(this.task);

  final TaskEntity task;
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
            AppText(
              label,
              color: foreground,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
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
              child: AppText(
                '$count',
                color: foreground,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
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
          const AppText.title('No tasks yet'),
          SizedBox(height: 8.h),
          const AppText('Add your first task to start tracking work.'),
          SizedBox(height: 16.h),
          AppButton(
            label: 'Create task',
            onPressed: onCreate,
            isExpanded: false,
          ),
        ],
      ),
    );
  }
}
