import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/input_validators.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../domain/entities/task_entity.dart';

class TaskEditorSheet extends StatefulWidget {
  const TaskEditorSheet({this.task, super.key});

  final TaskEntity? task;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final isEditing = widget.task != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, bottomInset + 20.h),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                isEditing ? 'Edit task' : 'Create task',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: _titleController,
                labelText: 'Title',
                validator: (value) => InputValidators.taskTitle(value ?? ''),
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: _descriptionController,
                labelText: 'Description',
                maxLines: 4,
              ),
              SizedBox(height: 20.h),
              AppButton(
                label: isEditing ? 'Save changes' : 'Create task',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final now = DateTime.now();
    final currentTask = widget.task;
    final task = TaskEntity(
      id: currentTask?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      isCompleted: currentTask?.isCompleted ?? false,
      createdAt: currentTask?.createdAt ?? now,
      updatedAt: now,
    );

    Navigator.of(context).pop(task);
  }
}
