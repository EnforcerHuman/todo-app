import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/sign_in.dart';
import '../../../domain/usecases/sign_up.dart';

part 'auth_form_event.dart';
part 'auth_form_state.dart';

class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  AuthFormBloc({required SignIn signIn, required SignUp signUp})
    : _signIn = signIn,
      _signUp = signUp,
      super(const AuthFormState()) {
    on<AuthFormSubmitted>(_onSubmitted);
    on<AuthFormResetRequested>(_onResetRequested);
  }

  final SignIn _signIn;
  final SignUp _signUp;

  Future<void> _onSubmitted(
    AuthFormSubmitted event,
    Emitter<AuthFormState> emit,
  ) async {
    emit(const AuthFormState(status: AuthFormStatus.submitting));

    try {
      if (event.mode == AuthFormMode.signIn) {
        await _signIn(email: event.email, password: event.password);
      } else {
        await _signUp(
          email: event.email,
          password: event.password,
          name: event.name,
        );
      }

      emit(const AuthFormState(status: AuthFormStatus.success));
    } catch (error) {
      emit(
        AuthFormState(
          status: AuthFormStatus.failure,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void _onResetRequested(
    AuthFormResetRequested event,
    Emitter<AuthFormState> emit,
  ) {
    emit(const AuthFormState());
  }
}
