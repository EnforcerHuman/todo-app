import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class AddTask {
  const AddTask(this._repository);

  final TaskRepository _repository;

  Future<void> call(TaskEntity task) => _repository.addTask(task);
}
