import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSectionCard extends StatelessWidget {
  const AppSectionCard({required this.child, this.padding, super.key});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: padding ?? EdgeInsets.all(20.w), child: child),
    );
  }
}
