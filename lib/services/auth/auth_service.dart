import 'package:testnotes/services/auth/auth_provider.dart';
import 'package:testnotes/services/auth/auth_user.dart';
import 'package:testnotes/services/auth/firebase_auth_provider.dart';

/// auth service isn;t going to be hard coded to use firebase Auth Provider but
/// instead would take an auth provider from you and then expose the auth
/// provider functionality to the user
class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
