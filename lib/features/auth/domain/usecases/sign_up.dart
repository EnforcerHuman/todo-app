import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  const SignUp(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call({
    required String email,
    required String password,
    required String name,
  }) {
    return _repository.signUp(email: email, password: password, name: name);
  }
}
