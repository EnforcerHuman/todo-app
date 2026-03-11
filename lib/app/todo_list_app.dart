import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_theme.dart';
import '../dependency_injection.dart';
import '../features/auth/presentation/blocs/auth/auth_bloc.dart';
import '../features/auth/presentation/blocs/auth_form/auth_form_bloc.dart';
import '../features/auth/presentation/screens/auth_gate_screen.dart';
import '../features/tasks/presentation/blocs/task/task_bloc.dart';

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.create();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: dependencies.authRepository),
        RepositoryProvider.value(value: dependencies.taskRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(
              listenToAuthState: dependencies.listenToAuthState,
              signOut: dependencies.signOut,
            )..add(const AuthSubscriptionRequested()),
          ),
          BlocProvider(
            create: (_) => AuthFormBloc(
              signIn: dependencies.signIn,
              signUp: dependencies.signUp,
            ),
          ),
          BlocProvider(
            create: (_) => TaskBloc(
              addTask: dependencies.addTask,
              deleteTask: dependencies.deleteTask,
              fetchTasks: dependencies.fetchTasks,
              toggleTaskCompletion: dependencies.toggleTaskCompletion,
              updateTask: dependencies.updateTask,
            ),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Task Flow',
            theme: AppTheme.lightTheme,
            home: child ?? const AuthGateScreen(),
          ),
          child: const AuthGateScreen(),
        ),
      ),
    );
  }
}
