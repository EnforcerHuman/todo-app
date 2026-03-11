part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthSubscriptionRequested extends AuthEvent {
  const AuthSubscriptionRequested();
}

final class AuthStateChanged extends AuthEvent {
  const AuthStateChanged(this.user);

  final AppUser? user;

  @override
  List<Object?> get props => [user];
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
