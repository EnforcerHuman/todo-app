import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_button.dart';
import 'app_text.dart';

class AppConfirmationDialog extends StatelessWidget {
  const AppConfirmationDialog({
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      title: AppText.title(title),
      content: AppText.medium(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: AppText(cancelLabel),
        ),
        SizedBox(
          width: 132.w,
          child: AppButton(
            label: confirmLabel,
            variant: isDestructive
                ? AppButtonVariant.destructive
                : AppButtonVariant.primary,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ),
      ],
    );
  }
}

Future<bool> showAppConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AppConfirmationDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      isDestructive: isDestructive,
    ),
  );

  return result ?? false;
}
