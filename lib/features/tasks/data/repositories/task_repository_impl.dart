import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/app_config.dart';
import '../../../../core/error/app_exception.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasource/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl({
    required FirebaseAuth auth,
    required http.Client client,
    required TaskRemoteDataSource remoteDataSource,
  }) : _auth = auth,
       _client = client,
       _remoteDataSource = remoteDataSource;

  final FirebaseAuth _auth;
  final http.Client _client;
  final TaskRemoteDataSource _remoteDataSource;

  @override
  Future<List<TaskEntity>> fetchTasks() async {
    final uri = await _buildCollectionUri();
    final tasks = await _remoteDataSource.fetchTasks(client: _client, uri: uri);
    tasks.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return tasks;
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    final uri = await _buildCollectionUri();
    await _remoteDataSource.addTask(
      client: _client,
      uri: uri,
      task: TaskModel.fromEntity(task),
    );
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final uri = await _buildItemUri(task.id);
    await _remoteDataSource.updateTask(
      client: _client,
      uri: uri,
      task: TaskModel.fromEntity(task),
    );
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final uri = await _buildItemUri(taskId);
    await _remoteDataSource.deleteTask(client: _client, uri: uri);
  }

  @override
  Future<void> toggleTaskCompletion({
    required String taskId,
    required bool isCompleted,
  }) async {
    final uri = await _buildItemUri(taskId);
    await _remoteDataSource.patchTask(
      client: _client,
      uri: uri,
      body: {
        'isCompleted': isCompleted,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<Uri> _buildCollectionUri() async {
    final user = _currentUser;
    final token = await user.getIdToken();
    final configuredUrl = Firebase.app().options.databaseURL;
    final baseUrl = configuredUrl?.isNotEmpty == true
        ? configuredUrl!
        : AppConfig.firebaseDatabaseUrl;

    if (baseUrl.isEmpty) {
      throw AppException(
        'Realtime Database URL is missing. Enable Firebase Realtime Database, '
        'rerun `flutterfire configure`, or run the app with '
        '`--dart-define=FIREBASE_DB_URL=https://YOUR_PROJECT_ID-default-rtdb.asia-southeast1.firebasedatabase.app`.',
      );
    }

    return Uri.parse('$baseUrl/users/${user.uid}/tasks.json?auth=$token');
  }

  Future<Uri> _buildItemUri(String taskId) async {
    final collectionUri = await _buildCollectionUri();
    final itemUrl = collectionUri.toString().replaceFirst(
      '/tasks.json',
      '/tasks/$taskId.json',
    );
    return Uri.parse(itemUrl);
  }

  User get _currentUser {
    final user = _auth.currentUser;
    if (user == null) {
      throw AppException('You need to sign in before managing tasks.');
    }
    return user;
  }
}
