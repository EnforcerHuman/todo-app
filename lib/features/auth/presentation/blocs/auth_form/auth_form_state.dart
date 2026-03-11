part of 'auth_form_bloc.dart';

enum AuthFormStatus { initial, submitting, success, failure }

class AuthFormState extends Equatable {
  const AuthFormState({this.status = AuthFormStatus.initial, this.message});

  final AuthFormStatus status;
  final String? message;

  @override
  List<Object?> get props => [status, message];
}
