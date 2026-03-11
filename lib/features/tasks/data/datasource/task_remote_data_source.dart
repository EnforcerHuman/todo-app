import 'dart:convert';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_service.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  const TaskRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  Future<List<TaskModel>> fetchTasks({required Uri uri}) async {
    final response = await _apiService.get(uri);
    _throwIfInvalid(response.statusCode);

    final body = jsonDecode(response.body);
    if (body == null) {
      return <TaskModel>[];
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

  Future<void> addTask({required Uri uri, required TaskModel task}) async {
    final response = await _apiService.post(uri, body: task.toJson());
    _throwIfInvalid(response.statusCode);
  }

  Future<void> updateTask({required Uri uri, required TaskModel task}) async {
    final response = await _apiService.patch(uri, body: task.toJson());
    _throwIfInvalid(response.statusCode);
  }

  Future<void> deleteTask({required Uri uri}) async {
    final response = await _apiService.delete(uri);
    _throwIfInvalid(response.statusCode);
  }

  Future<void> patchTask({
    required Uri uri,
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiService.patch(uri, body: body);
    _throwIfInvalid(response.statusCode);
  }

  void _throwIfInvalid(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return;
    }

    throw AppException('Task request failed with status $statusCode.');
  }
}
