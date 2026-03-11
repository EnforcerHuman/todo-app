import 'package:flutter/material.dart';

enum AppTextVariant { small, medium, large, title }

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    this.variant = AppTextVariant.medium,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    super.key,
  });

  const AppText.small(
    this.data, {
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    super.key,
  }) : variant = AppTextVariant.small;

  const AppText.medium(
    this.data, {
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    super.key,
  }) : variant = AppTextVariant.medium;

  const AppText.large(
    this.data, {
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    super.key,
  }) : variant = AppTextVariant.large;

  const AppText.title(
    this.data, {
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    super.key,
  }) : variant = AppTextVariant.title;

  final String data;
  final AppTextVariant variant;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final baseStyle = switch (variant) {
      AppTextVariant.small => theme.bodySmall ?? theme.bodyMedium,
      AppTextVariant.medium => theme.bodyMedium,
      AppTextVariant.large => theme.bodyLarge,
      AppTextVariant.title => theme.titleLarge,
    };

    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: baseStyle
          ?.copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight)
          .merge(style),
    );
  }
}
