import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'features/auth/data/datasource/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/listen_to_auth_state.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/tasks/data/datasource/task_remote_data_source.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/domain/repositories/task_repository.dart';
import 'features/tasks/domain/usecases/add_task.dart';
import 'features/tasks/domain/usecases/delete_task.dart';
import 'features/tasks/domain/usecases/fetch_tasks.dart';
import 'features/tasks/domain/usecases/toggle_task_completion.dart';
import 'features/tasks/domain/usecases/update_task.dart';

class AppDependencies {
  AppDependencies._({
    required this.authRepository,
    required this.taskRepository,
    required this.listenToAuthState,
    required this.signIn,
    required this.signOut,
    required this.signUp,
    required this.fetchTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.toggleTaskCompletion,
  });

  final AuthRepository authRepository;
  final TaskRepository taskRepository;
  final ListenToAuthState listenToAuthState;
  final SignIn signIn;
  final SignOut signOut;
  final SignUp signUp;
  final FetchTasks fetchTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final ToggleTaskCompletion toggleTaskCompletion;

  factory AppDependencies.create() {
    final firebaseAuth = FirebaseAuth.instance;
    final client = http.Client();

    final authRepository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSource(firebaseAuth: firebaseAuth),
    );

    final taskRepository = TaskRepositoryImpl(
      auth: firebaseAuth,
      client: client,
      remoteDataSource: const TaskRemoteDataSource(),
    );

    return AppDependencies._(
      authRepository: authRepository,
      taskRepository: taskRepository,
      listenToAuthState: ListenToAuthState(authRepository),
      signIn: SignIn(authRepository),
      signOut: SignOut(authRepository),
      signUp: SignUp(authRepository),
      fetchTasks: FetchTasks(taskRepository),
      addTask: AddTask(taskRepository),
      updateTask: UpdateTask(taskRepository),
      deleteTask: DeleteTask(taskRepository),
      toggleTaskCompletion: ToggleTaskCompletion(taskRepository),
    );
  }
}
