import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.isCompleted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TaskModel.fromJson(String id, Map<String, dynamic> json) {
    return TaskModel(
      id: id,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  factory TaskModel.fromEntity(TaskEntity task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
