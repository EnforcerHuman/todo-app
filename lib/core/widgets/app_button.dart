import 'package:flutter/material.dart';

import 'app_text.dart';

enum AppButtonVariant { primary, secondary, destructive }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.isExpanded = true,
    this.variant = AppButtonVariant.primary,
    this.minimumHeight,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isExpanded;
  final AppButtonVariant variant;
  final double? minimumHeight;

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context);
    final child = icon == null
        ? AppText(
            label,
            color: _foregroundColor(context),
            fontWeight: FontWeight.w600,
          )
        : Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon!,
              const SizedBox(width: 8),
              Flexible(
                child: AppText(
                  label,
                  color: _foregroundColor(context),
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final button = ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );

    if (!isExpanded) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }

  ButtonStyle _resolveStyle(BuildContext context) {
    final themeStyle = Theme.of(context).elevatedButtonTheme.style;
    final colors = Theme.of(context).colorScheme;

    final background = switch (variant) {
      AppButtonVariant.primary => colors.primary,
      AppButtonVariant.secondary => const Color(0xFFF2F4F7),
      AppButtonVariant.destructive => const Color(0xFFDC2626),
    };

    final foreground = _foregroundColor(context);

    return (themeStyle ?? const ButtonStyle()).copyWith(
      minimumSize: minimumHeight == null
          ? null
          : WidgetStatePropertyAll(Size.fromHeight(minimumHeight!)),
      backgroundColor: WidgetStatePropertyAll(background),
      foregroundColor: WidgetStatePropertyAll(foreground),
      elevation: variant == AppButtonVariant.secondary
          ? const WidgetStatePropertyAll(0)
          : null,
    );
  }

  Color _foregroundColor(BuildContext context) {
    return switch (variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.secondary => const Color(0xFF111827),
      AppButtonVariant.destructive => Colors.white,
    };
  }
}
