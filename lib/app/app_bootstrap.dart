import 'package:flutter/material.dart';

import '../core/services/firebase_initializer.dart';
import '../features/setup/presentation/screens/firebase_setup_screen.dart';
import 'todo_list_app.dart';

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: FirebaseInitializer.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: FirebaseSetupScreen(error: snapshot.error.toString()),
          );
        }

        return const TodoListApp();
      },
    );
  }
}
