import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class FetchTasks {
  const FetchTasks(this._repository);

  final TaskRepository _repository;

  Future<List<TaskEntity>> call() => _repository.fetchTasks();
}
