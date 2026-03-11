import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/app_exception.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  const TaskRemoteDataSource();

  Future<List<TaskModel>> fetchTasks({
    required http.Client client,
    required Uri uri,
  }) async {
    final response = await client.get(uri);
    _throwIfInvalid(response);

    final body = jsonDecode(response.body);
    if (body == null) {
      return const [];
    }

    final map = Map<String, dynamic>.from(body as Map);
    return map.entries
        .map(
          (entry) => TaskModel.fromJson(
            entry.key,
            Map<String, dynamic>.from(entry.value as Map),
          ),
        )
        .toList();
  }

  Future<void> addTask({
    required http.Client client,
    required Uri uri,
    required TaskModel task,
  }) async {
    final response = await client.post(uri, body: jsonEncode(task.toJson()));
    _throwIfInvalid(response);
  }

  Future<void> updateTask({
    required http.Client client,
    required Uri uri,
    required TaskModel task,
  }) async {
    final response = await client.patch(uri, body: jsonEncode(task.toJson()));
    _throwIfInvalid(response);
  }

  Future<void> deleteTask({
    required http.Client client,
    required Uri uri,
  }) async {
    final response = await client.delete(uri);
    _throwIfInvalid(response);
  }

  Future<void> patchTask({
    required http.Client client,
    required Uri uri,
    required Map<String, dynamic> body,
  }) async {
    final response = await client.patch(uri, body: jsonEncode(body));
    _throwIfInvalid(response);
  }

  void _throwIfInvalid(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw AppException(
      'Task request failed with status ${response.statusCode}.',
    );
  }
}
