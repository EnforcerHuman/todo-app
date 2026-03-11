part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

final class TasksRequested extends TaskEvent {
  const TasksRequested();
}

final class TaskCreated extends TaskEvent {
  const TaskCreated(this.task);

  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}

final class TaskUpdated extends TaskEvent {
  const TaskUpdated(this.task);

  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}

final class TaskDeleted extends TaskEvent {
  const TaskDeleted(this.taskId);

  final String taskId;

  @override
  List<Object?> get props => [taskId];
}

final class TaskCompletionToggled extends TaskEvent {
  const TaskCompletionToggled({
    required this.taskId,
    required this.isCompleted,
  });

  final String taskId;
  final bool isCompleted;

  @override
  List<Object?> get props => [taskId, isCompleted];
}
