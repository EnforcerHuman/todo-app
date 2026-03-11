import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    const background = Color(0xFFF5F7FB);
    const surface = Colors.white;
    const primary = Color(0xFF155EEF);
    const secondary = Color(0xFF16A34A);
    const accent = Color(0xFFF97316);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.r)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: Size.fromHeight(54.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Color(0xFFE8EEF9),
        selectedColor: accent,
        secondarySelectedColor: accent,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34.sp,
          fontWeight: FontWeight.w700,
          color: Color(0xFF101828),
        ),
        headlineSmall: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: Color(0xFF101828),
        ),
        titleLarge: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: Color(0xFF101828),
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          height: 1.45,
          color: Color(0xFF344054),
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          height: 1.4,
          color: Color(0xFF667085),
        ),
      ),
    );
  }
}
