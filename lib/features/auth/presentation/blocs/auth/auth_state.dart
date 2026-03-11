part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.unknown, this.user});

  final AuthStatus status;
  final AppUser? user;

  @override
  List<Object?> get props => [status, user];
}
