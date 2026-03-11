import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/task_entity.dart';
import '../../../domain/usecases/add_task.dart';
import '../../../domain/usecases/delete_task.dart';
import '../../../domain/usecases/fetch_tasks.dart';
import '../../../domain/usecases/toggle_task_completion.dart';
import '../../../domain/usecases/update_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required AddTask addTask,
    required DeleteTask deleteTask,
    required FetchTasks fetchTasks,
    required ToggleTaskCompletion toggleTaskCompletion,
    required UpdateTask updateTask,
  }) : _addTask = addTask,
       _deleteTask = deleteTask,
       _fetchTasks = fetchTasks,
       _toggleTaskCompletion = toggleTaskCompletion,
       _updateTask = updateTask,
       super(const TaskState()) {
    on<TasksRequested>(_onRequested);
    on<TaskCreated>(_onCreated);
    on<TaskUpdated>(_onUpdated);
    on<TaskDeleted>(_onDeleted);
    on<TaskCompletionToggled>(_onCompletionToggled);
  }

  final AddTask _addTask;
  final DeleteTask _deleteTask;
  final FetchTasks _fetchTasks;
  final ToggleTaskCompletion _toggleTaskCompletion;
  final UpdateTask _updateTask;

  Future<void> _onRequested(
    TasksRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatus.loading));

    try {
      final tasks = await _fetchTasks();
      emit(state.copyWith(status: TaskStatus.success, tasks: tasks));
    } catch (error) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onCreated(TaskCreated event, Emitter<TaskState> emit) async {
    await _submitMutation(
      emit,
      () => _addTask(event.task),
      successMessage: 'Task added.',
    );
  }

  Future<void> _onUpdated(TaskUpdated event, Emitter<TaskState> emit) async {
    await _submitMutation(
      emit,
      () => _updateTask(event.task),
      successMessage: 'Task updated.',
    );
  }

  Future<void> _onDeleted(TaskDeleted event, Emitter<TaskState> emit) async {
    await _submitMutation(
      emit,
      () => _deleteTask(event.taskId),
      successMessage: 'Task deleted.',
    );
  }

  Future<void> _onCompletionToggled(
    TaskCompletionToggled event,
    Emitter<TaskState> emit,
  ) async {
    await _submitMutation(
      emit,
      () => _toggleTaskCompletion(
        taskId: event.taskId,
        isCompleted: event.isCompleted,
      ),
      successMessage: event.isCompleted
          ? 'Task marked as done.'
          : 'Task marked as active.',
    );
  }

  Future<void> _submitMutation(
    Emitter<TaskState> emit,
    Future<void> Function() action, {
    required String successMessage,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearMessage: true));

    try {
      await action();
      final tasks = await _fetchTasks();
      emit(
        state.copyWith(
          status: TaskStatus.success,
          tasks: tasks,
          isSubmitting: false,
          message: successMessage,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          isSubmitting: false,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
