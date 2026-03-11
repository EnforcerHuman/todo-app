part of 'task_bloc.dart';

enum TaskStatus { initial, loading, success, failure }

enum TaskMutationType { none, create, update, delete, toggle }

class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.isSubmitting = false,
    this.activeMutation = TaskMutationType.none,
    this.activeTaskId,
    this.message,
  });

  final TaskStatus status;
  final List<TaskEntity> tasks;
  final bool isSubmitting;
  final TaskMutationType activeMutation;
  final String? activeTaskId;
  final String? message;

  TaskState copyWith({
    TaskStatus? status,
    List<TaskEntity>? tasks,
    bool? isSubmitting,
    TaskMutationType? activeMutation,
    String? activeTaskId,
    String? message,
    bool clearActiveTaskId = false,
    bool clearMessage = false,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      activeMutation: activeMutation ?? this.activeMutation,
      activeTaskId: clearActiveTaskId
          ? null
          : activeTaskId ?? this.activeTaskId,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tasks,
    isSubmitting,
    activeMutation,
    activeTaskId,
    message,
  ];
}
