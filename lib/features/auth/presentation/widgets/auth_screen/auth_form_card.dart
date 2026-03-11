import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/utils/input_validators.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../blocs/auth_form/auth_form_bloc.dart';

class AuthFormCard extends StatefulWidget {
  const AuthFormCard({
    required this.mode,
    required this.onModeChanged,
    this.dense = false,
    this.ultraDense = false,
    super.key,
  });

  final AuthFormMode mode;
  final ValueChanged<AuthFormMode> onModeChanged;
  final bool dense;
  final bool ultraDense;

  @override
  State<AuthFormCard> createState() => _AuthFormCardState();
}

class _AuthFormCardState extends State<AuthFormCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSignUp = widget.mode == AuthFormMode.signUp;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          widget.ultraDense
              ? 14.w
              : widget.dense
              ? 18.w
              : 24.w,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 380;
            final isExtraNarrow = constraints.maxWidth < 340;
            final adaptiveUltraDense =
                widget.ultraDense ||
                constraints.maxHeight < 390.h ||
                (isExtraNarrow && constraints.maxHeight < 470.h);
            final adaptiveDense =
                adaptiveUltraDense ||
                widget.dense ||
                constraints.maxHeight < 470.h ||
                isNarrow;
            final fieldGap = adaptiveUltraDense
                ? 7.h
                : adaptiveDense
                ? 9.h
                : 14.h;
            final sectionGap = adaptiveUltraDense
                ? 9.h
                : adaptiveDense
                ? 12.h
                : 18.h;
            final fieldContentPadding = EdgeInsets.symmetric(
              horizontal: adaptiveUltraDense
                  ? 12.w
                  : adaptiveDense
                  ? 14.w
                  : 18.w,
              vertical: adaptiveUltraDense
                  ? 12.h
                  : adaptiveDense
                  ? 14.h
                  : 16.h,
            );
            final headerFontSize = adaptiveUltraDense
                ? 19.sp
                : adaptiveDense
                ? 21.sp
                : null;
            final buttonHeight = adaptiveUltraDense
                ? 44.h
                : adaptiveDense
                ? 48.h
                : 54.h;

            return BlocBuilder<AuthFormBloc, AuthFormState>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!adaptiveUltraDense)
                          AppText.title(
                            'Task Flow',
                            fontSize: adaptiveDense ? 18.sp : null,
                          ),
                        if (!adaptiveUltraDense)
                          SizedBox(height: adaptiveDense ? 4.h : 10.h),
                        AppText(
                          isSignUp ? 'Create account' : 'Sign in',
                          style: Theme.of(context).textTheme.headlineSmall,
                          fontSize: headerFontSize,
                        ),
                        SizedBox(height: 4.h),
                        if (!adaptiveUltraDense)
                          AppText.medium(
                            isSignUp
                                ? 'Create your workspace with email and password.'
                                : 'Use your email and password to continue.',
                            fontSize: adaptiveDense ? 13.sp : null,
                          ),
                        SizedBox(height: sectionGap),
                        _AuthModeSelector(
                          mode: widget.mode,
                          onModeChanged: widget.onModeChanged,
                          dense: adaptiveDense,
                          ultraDense: adaptiveUltraDense,
                        ),
                        SizedBox(height: sectionGap),
                        if (isSignUp) ...[
                          AppTextField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              fontSize: adaptiveDense ? 14.sp : 15.sp,
                            ),
                            labelText: 'Full name',
                            isDense: adaptiveDense,
                            contentPadding: fieldContentPadding,
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Name is required.'
                                : null,
                          ),
                          SizedBox(height: fieldGap),
                        ],
                        AppTextField(
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: adaptiveDense ? 14.sp : 15.sp,
                          ),
                          labelText: 'Email',
                          isDense: adaptiveDense,
                          contentPadding: fieldContentPadding,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              InputValidators.email(value ?? ''),
                        ),
                        SizedBox(height: fieldGap),
                        AppTextField(
                          controller: _passwordController,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                            fontSize: adaptiveDense ? 14.sp : 15.sp,
                          ),
                          labelText: 'Password',
                          isDense: adaptiveDense,
                          contentPadding: fieldContentPadding,
                          obscureText: true,
                          validator: (value) =>
                              InputValidators.password(value ?? ''),
                        ),
                        SizedBox(height: sectionGap),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(buttonHeight),
                            ),
                            onPressed: state.status == AuthFormStatus.submitting
                                ? null
                                : _submit,
                            child: state.status == AuthFormStatus.submitting
                                ? SizedBox(
                                    height: 20.w,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : AppText(
                                    isSignUp ? 'Create account' : 'Sign in',
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: adaptiveUltraDense
                              ? 2.h
                              : adaptiveDense
                              ? 6.h
                              : 10.h,
                        ),
                        Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: adaptiveUltraDense ? 4.h : 8.h,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              widget.onModeChanged(
                                isSignUp
                                    ? AuthFormMode.signIn
                                    : AuthFormMode.signUp,
                              );
                            },
                            child: AppText(
                              isSignUp
                                  ? 'Already have an account? Sign in'
                                  : 'Don\'t have an account? Sign up',
                              textAlign: TextAlign.center,
                              fontSize: adaptiveUltraDense ? 12.sp : 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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

    context.read<AuthFormBloc>().add(
      AuthFormSubmitted(
        mode: widget.mode,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
      ),
    );
  }
}

class _AuthModeSelector extends StatelessWidget {
  const _AuthModeSelector({
    required this.mode,
    required this.onModeChanged,
    required this.dense,
    required this.ultraDense,
  });

  final AuthFormMode mode;
  final ValueChanged<AuthFormMode> onModeChanged;
  final bool dense;
  final bool ultraDense;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: ultraDense
          ? 10.w
          : dense
          ? 12.w
          : 14.w,
      vertical: ultraDense
          ? 10.h
          : dense
          ? 12.h
          : 14.h,
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(18.r),
      ),
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: _AuthModeButton(
              label: 'Sign in',
              icon: Icons.login_rounded,
              selected: mode == AuthFormMode.signIn,
              dense: dense,
              ultraDense: ultraDense,
              padding: padding,
              onTap: () => onModeChanged(AuthFormMode.signIn),
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: _AuthModeButton(
              label: 'Sign up',
              icon: Icons.person_add_alt_1_rounded,
              selected: mode == AuthFormMode.signUp,
              dense: dense,
              ultraDense: ultraDense,
              padding: padding,
              onTap: () => onModeChanged(AuthFormMode.signUp),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthModeButton extends StatelessWidget {
  const _AuthModeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.dense,
    required this.ultraDense,
    required this.padding,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool dense;
  final bool ultraDense;
  final EdgeInsets padding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : const Color(0xFF475467);

    return Material(
      color: selected ? const Color(0xFF155EEF) : Colors.transparent,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: ultraDense
                    ? 16.sp
                    : dense
                    ? 17.sp
                    : 18.sp,
                color: foreground,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: AppText(
                  label,
                  overflow: TextOverflow.ellipsis,
                  color: foreground,
                  fontSize: ultraDense
                      ? 12.sp
                      : dense
                      ? 13.sp
                      : 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
