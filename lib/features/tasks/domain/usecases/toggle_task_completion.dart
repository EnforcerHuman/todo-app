import '../repositories/task_repository.dart';

class ToggleTaskCompletion {
  const ToggleTaskCompletion(this._repository);

  final TaskRepository _repository;

  Future<void> call({required String taskId, required bool isCompleted}) {
    return _repository.toggleTaskCompletion(
      taskId: taskId,
      isCompleted: isCompleted,
    );
  }
}
