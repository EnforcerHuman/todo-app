import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/input_validators.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../domain/entities/task_entity.dart';
import '../../blocs/task/task_bloc.dart';

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
  bool _hasSubmitted = false;

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
        child: BlocConsumer<TaskBloc, TaskState>(
          listenWhen: (previous, current) =>
              previous.isSubmitting != current.isSubmitting ||
              previous.status != current.status ||
              previous.message != current.message,
          listener: (context, state) {
            final shouldClose =
                !state.isSubmitting &&
                _hasSubmitted &&
                state.status == TaskStatus.success &&
                (state.activeMutation == TaskMutationType.create ||
                    state.activeMutation == TaskMutationType.update);

            if (shouldClose && mounted) {
              Navigator.of(context).pop();
              return;
            }

            final shouldShowError =
                !state.isSubmitting &&
                _hasSubmitted &&
                state.status == TaskStatus.failure &&
                state.message != null &&
                state.message!.isNotEmpty;

            if (shouldShowError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: AppText(state.message!)));
            }
          },
          builder: (context, state) {
            final isSaving =
                state.isSubmitting &&
                state.activeMutation ==
                    (isEditing
                        ? TaskMutationType.update
                        : TaskMutationType.create);

            return Form(
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
                    validator: (value) =>
                        InputValidators.taskTitle(value ?? ''),
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: _descriptionController,
                    labelText: 'Description',
                    maxLines: 4,
                  ),
                  SizedBox(height: 20.h),
                  AppButton(
                    label: isEditing
                        ? (isSaving ? 'Saving...' : 'Save changes')
                        : (isSaving ? 'Creating...' : 'Create task'),
                    onPressed: isSaving ? null : _submit,
                    icon: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                  ),
                ],
              ),
            );
          },
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

    _hasSubmitted = true;
    context.read<TaskBloc>().add(
      widget.task == null ? TaskCreated(task) : TaskUpdated(task),
    );
  }
}
