import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text.dart';
import '../blocs/auth_form/auth_form_bloc.dart';
import '../widgets/auth_screen/auth_form_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthFormMode _mode = AuthFormMode.signIn;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthFormBloc, AuthFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthFormStatus.failure && state.message != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FBFF), Color(0xFFEEF4FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 920;
                final isShort = constraints.maxHeight < 760;
                final isVeryShort = constraints.maxHeight < 690;
                final isUltraShort = constraints.maxHeight < 620;
                final horizontalPadding = constraints.maxWidth < 420
                    ? 14.w
                    : 24.w;
                final verticalPadding = isShort ? 12.h : 20.h;
                final availableHeight =
                    constraints.maxHeight - (verticalPadding * 2);
                final introHeight = isWide
                    ? availableHeight
                    : (availableHeight * (isUltraShort ? 0.24 : 0.29)).clamp(
                        110.0,
                        isVeryShort ? 170.0 : 230.0,
                      );

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1120),
                      child: SizedBox(
                        height: availableHeight,
                        child: isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: _AuthIntroPanel(
                                      mode: _mode,
                                      compact: isShort,
                                    ),
                                  ),
                                  SizedBox(width: 28.w),
                                  SizedBox(
                                    width: 430.w.clamp(380, 460),
                                    child: AuthFormCard(
                                      mode: _mode,
                                      onModeChanged: _onModeChanged,
                                      dense: isShort,
                                      ultraDense: isVeryShort,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: introHeight,
                                    child: _AuthIntroPanel(
                                      mode: _mode,
                                      compact: isShort || isUltraShort,
                                      hideChips: isVeryShort || isUltraShort,
                                    ),
                                  ),
                                  SizedBox(height: isShort ? 12.h : 18.h),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 520.w,
                                        ),
                                        child: AuthFormCard(
                                          mode: _mode,
                                          onModeChanged: _onModeChanged,
                                          dense: isShort,
                                          ultraDense: isVeryShort,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onModeChanged(AuthFormMode mode) {
    context.read<AuthFormBloc>().add(const AuthFormResetRequested());
    setState(() => _mode = mode);
  }
}

class _AuthIntroPanel extends StatelessWidget {
  const _AuthIntroPanel({
    required this.mode,
    this.compact = false,
    this.hideChips = false,
  });

  final AuthFormMode mode;
  final bool compact;
  final bool hideChips;

  @override
  Widget build(BuildContext context) {
    final isSignUp = mode == AuthFormMode.signUp;

    return LayoutBuilder(
      builder: (context, constraints) {
        final ultraTight = constraints.maxHeight < 130;
        final veryTight = constraints.maxHeight < 170;
        final tight = constraints.maxHeight < 220;
        final resolvedCompact = compact || tight;
        final showSubtitle = !ultraTight;
        final showChips = !hideChips && !tight;
        final padding = ultraTight
            ? EdgeInsets.all(14.w)
            : veryTight
            ? EdgeInsets.all(16.w)
            : EdgeInsets.all(resolvedCompact ? 20.w : 26.w);

        return Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF155EEF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ultraTight ? 10.w : 12.w,
                  vertical: ultraTight ? 6.h : 8.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: AppText(
                  isSignUp ? 'Create your account' : 'Welcome back',
                  color: Colors.white,
                  fontSize: ultraTight
                      ? 10.sp
                      : veryTight
                      ? 11.sp
                      : 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: ultraTight
                    ? 6.h
                    : veryTight
                    ? 8.h
                    : resolvedCompact
                    ? 12.h
                    : 22.h,
              ),
              AppText(
                isSignUp
                    ? 'Start organizing work with a clean and focused task flow.'
                    : 'Sign in to continue where you left off.',
                maxLines: ultraTight
                    ? 1
                    : veryTight
                    ? 2
                    : 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontSize: ultraTight
                      ? 15.sp
                      : veryTight
                      ? 18.sp
                      : resolvedCompact
                      ? 22.sp
                      : 32.sp,
                  height: 1.06,
                ),
              ),
              if (showSubtitle) ...[
                SizedBox(
                  height: ultraTight
                      ? 4.h
                      : veryTight
                      ? 6.h
                      : resolvedCompact
                      ? 8.h
                      : 12.h,
                ),
                AppText.large(
                  'Fast authentication, responsive layouts, and a clearer daily task rhythm.',
                  maxLines: veryTight ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white.withValues(alpha: 0.84),
                  fontSize: veryTight
                      ? 12.sp
                      : resolvedCompact
                      ? 13.sp
                      : null,
                ),
              ],
              if (showChips) ...[
                SizedBox(height: resolvedCompact ? 12.h : 24.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: const [
                    _IntroChip(label: 'Email auth'),
                    _IntroChip(label: 'Realtime sync'),
                    _IntroChip(label: 'Minimal workflow'),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _IntroChip extends StatelessWidget {
  const _IntroChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: AppText(
        label,
        color: Colors.white,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
