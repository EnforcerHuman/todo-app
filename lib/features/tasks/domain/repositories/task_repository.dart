import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> fetchTasks();
  Future<void> addTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String taskId);
  Future<void> toggleTaskCompletion({
    required String taskId,
    required bool isCompleted,
  });
}
