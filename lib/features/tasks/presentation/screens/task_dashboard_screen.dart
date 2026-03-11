import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_text.dart';
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../widgets/task_dashboard/task_dashboard_view.dart';

class TaskDashboardScreen extends StatefulWidget {
  const TaskDashboardScreen({super.key});

  @override
  State<TaskDashboardScreen> createState() => _TaskDashboardScreenState();
}

class _TaskDashboardScreenState extends State<TaskDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const TasksRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listenWhen: (previous, current) => previous.message != current.message,
      listener: (context, state) {
        final message = state.message;
        if (message == null || message.isEmpty) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: AppText(message)));
      },
      child: TaskDashboardView(
        onLogout: () {
          context.read<AuthBloc>().add(const AuthSignOutRequested());
        },
      ),
    );
  }
}
