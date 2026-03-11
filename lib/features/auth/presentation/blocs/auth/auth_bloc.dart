import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_user.dart';
import '../../../domain/usecases/listen_to_auth_state.dart';
import '../../../domain/usecases/sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required ListenToAuthState listenToAuthState,
    required SignOut signOut,
  }) : _listenToAuthState = listenToAuthState,
       _signOut = signOut,
       super(const AuthState()) {
    on<AuthSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthStateChanged>(_onStateChanged);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  final ListenToAuthState _listenToAuthState;
  final SignOut _signOut;
  StreamSubscription<AppUser?>? _subscription;

  Future<void> _onSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _subscription?.cancel();
    _subscription = _listenToAuthState().listen(
      (user) => add(AuthStateChanged(user)),
    );
  }

  void _onStateChanged(AuthStateChanged event, Emitter<AuthState> emit) {
    if (event.user == null) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }

    emit(AuthState(status: AuthStatus.authenticated, user: event.user));
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _signOut();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
