part of 'auth_form_bloc.dart';

enum AuthFormMode { signIn, signUp }

sealed class AuthFormEvent extends Equatable {
  const AuthFormEvent();

  @override
  List<Object?> get props => [];
}

final class AuthFormSubmitted extends AuthFormEvent {
  const AuthFormSubmitted({
    required this.mode,
    required this.email,
    required this.password,
    this.name = '',
  });

  final AuthFormMode mode;
  final String email;
  final String password;
  final String name;

  @override
  List<Object?> get props => [mode, email, password, name];
}

final class AuthFormResetRequested extends AuthFormEvent {
  const AuthFormResetRequested();
}
