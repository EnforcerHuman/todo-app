import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/app_text.dart';
import '../../../domain/entities/task_entity.dart';
import '../../blocs/task/task_bloc.dart';
import '../../screens/settings_screen.dart';
import 'task_editor_sheet.dart';
import 'task_header.dart';
import 'task_list_section.dart';
import 'task_overview_panel.dart';

class TaskDashboardView extends StatefulWidget {
  const TaskDashboardView({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  State<TaskDashboardView> createState() => _TaskDashboardViewState();
}

class _TaskDashboardViewState extends State<TaskDashboardView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 700;

    return Scaffold(
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () => _openEditor(context),
              icon: const Icon(Icons.add_task_rounded),
              label: const AppText('Add task'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) {
          setState(() => _currentIndex = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_rtl_outlined),
            selectedIcon: Icon(Icons.checklist_rtl_rounded),
            label: 'Tasks',
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            final tabs = [
              _HomeTabView(
                tasks: state.tasks,
                isCompact: !isTablet,
                onCreate: () => _openEditor(context),
                onOpenSettings: () => _openSettings(context),
              ),
              _TasksTabView(
                isCompact: !isTablet,
                isLoading: state.status == TaskStatus.loading,
                isSubmitting: state.isSubmitting,
                tasks: state.tasks,
                onRefresh: () =>
                    context.read<TaskBloc>().add(const TasksRequested()),
                onCreate: () => _openEditor(context),
                onDelete: (taskId) =>
                    context.read<TaskBloc>().add(TaskDeleted(taskId)),
                onEdit: (task) => _openEditor(context, task: task),
                onToggle: (task, value) {
                  context.read<TaskBloc>().add(
                    TaskCompletionToggled(taskId: task.id, isCompleted: value),
                  );
                },
              ),
            ];

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: tabs[_currentIndex],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {TaskEntity? task}) async {
    final bloc = context.read<TaskBloc>();
    final result = await showModalBottomSheet<TaskEntity>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => TaskEditorSheet(task: task),
    );

    if (result == null || !context.mounted) {
      return;
    }

    bloc.add(task == null ? TaskCreated(result) : TaskUpdated(result));
  }

  Future<void> _openSettings(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsScreen(onLogout: widget.onLogout),
      ),
    );
  }
}

class _HomeTabView extends StatelessWidget {
  const _HomeTabView({
    required this.tasks,
    required this.isCompact,
    required this.onCreate,
    required this.onOpenSettings,
  });

  final List<TaskEntity> tasks;
  final bool isCompact;
  final VoidCallback onCreate;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 420 ? 14.w : 20.w;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20.h,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: EdgeInsets.only(bottom: 28.h),
                children: [
                  TaskHeader(
                    tasks: tasks,
                    onCreate: onCreate,
                    onOpenSettings: onOpenSettings,
                    isCompact: isCompact,
                  ),
                  SizedBox(height: 16.h),
                  TaskOverviewPanel(tasks: tasks, isCompact: isCompact),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TasksTabView extends StatelessWidget {
  const _TasksTabView({
    required this.isCompact,
    required this.isLoading,
    required this.isSubmitting,
    required this.tasks,
    required this.onRefresh,
    required this.onCreate,
    required this.onDelete,
    required this.onEdit,
    required this.onToggle,
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 420 ? 14.w : 20.w;
        final compactLayout = constraints.maxWidth < 760;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20.h,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: compactLayout ? 1000 : 1080,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Tasks',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 6.h),
                  const AppText.medium(
                    'Plan, update, and complete everything from one focused list.',
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: TaskListSection(
                      isCompact: compactLayout || isCompact,
                      isLoading: isLoading,
                      isSubmitting: isSubmitting,
                      tasks: tasks,
                      onRefresh: onRefresh,
                      onCreate: onCreate,
                      onDelete: onDelete,
                      onEdit: onEdit,
                      onToggle: onToggle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
