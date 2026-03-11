import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/services/network_info.dart';
import '../models/app_user_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required NetworkInfo networkInfo,
  }) : _firebaseAuth = firebaseAuth,
       _networkInfo = networkInfo;

  final FirebaseAuth _firebaseAuth;
  final NetworkInfo _networkInfo;

  Stream<AppUserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  Future<AppUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _networkInfo.ensureConnected();
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return _mapUser(credential.user)!;
    } on FirebaseAuthException catch (error) {
      throw AppException(_mapAuthException(error));
    }
  }

  Future<AppUserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await _networkInfo.ensureConnected();
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await credential.user?.updateDisplayName(name.trim());
      await credential.user?.reload();

      return _mapUser(_firebaseAuth.currentUser)!;
    } on FirebaseAuthException catch (error) {
      throw AppException(_mapAuthException(error));
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      throw AppException(_mapAuthException(error));
    }
  }

  AppUserModel? _mapUser(User? user) {
    if (user == null) {
      return null;
    }

    return AppUserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
    );
  }

  String _mapAuthException(FirebaseAuthException error) {
    final rawMessage = error.message ?? 'Authentication failed.';
    final normalizedCode = error.code.toLowerCase();
    final normalizedMessage = rawMessage.toLowerCase();

    final isConfigNotFound =
        normalizedCode == 'internal-error' &&
        normalizedMessage.contains('configuration_not_found');

    if (isConfigNotFound) {
      return 'Firebase Auth Android configuration is incomplete for '
          '`com.example.todo_list`. In Firebase console, open the Android app, '
          'add this debug SHA-1 `DB:2F:DF:48:35:20:48:95:3D:B4:D6:B8:1F:64:46:6D:73:C8:CB:07` '
          'and SHA-256 '
          '`78:22:00:FA:CD:C3:1E:51:D2:52:3F:5D:15:65:F2:18:EA:4A:0E:10:5B:4F:25:F1:F5:D7:6F:26:3B:13:DD:65`, '
          'then download the updated `google-services.json`. Also make sure '
          'Email/Password sign-in is enabled.';
    }

    switch (normalizedCode) {
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Use a stronger password with at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Try again in a few minutes.';
      default:
        return rawMessage;
    }
  }
}
