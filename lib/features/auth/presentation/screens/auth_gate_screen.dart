import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../tasks/presentation/screens/task_dashboard_screen.dart';
import '../blocs/auth/auth_bloc.dart';
import 'auth_screen.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return const TaskDashboardScreen();
        }

        if (state.status == AuthStatus.unknown) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const AuthScreen();
      },
    );
  }
}
