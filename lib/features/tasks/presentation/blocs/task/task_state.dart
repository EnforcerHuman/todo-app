part of 'task_bloc.dart';

enum TaskStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.isSubmitting = false,
    this.message,
  });

  final TaskStatus status;
  final List<TaskEntity> tasks;
  final bool isSubmitting;
  final String? message;

  TaskState copyWith({
    TaskStatus? status,
    List<TaskEntity>? tasks,
    bool? isSubmitting,
    String? message,
    bool clearMessage = false,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, tasks, isSubmitting, message];
}
