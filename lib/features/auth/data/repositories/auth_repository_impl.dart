import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AppUser?> authStateChanges() => _remoteDataSource.authStateChanges();

  @override
  Future<AppUser> signIn({required String email, required String password}) {
    return _remoteDataSource.signIn(email: email, password: password);
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
  }) {
    return _remoteDataSource.signUp(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<void> signOut() => _remoteDataSource.signOut();
}
