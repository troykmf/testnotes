import 'package:flutter_test/flutter_test.dart';
import 'package:testnotes/services/auth/auth_exceptions.dart';
import 'package:testnotes/services/auth/auth_provider.dart';
import 'package:testnotes/services/auth/auth_user.dart';

void main() {
  //read on DEPENDENCY INJECTION
  /// in other to create a mock auth provider
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('soeild not be initialized to begin with', () {
      expect(provider.isInitialzed, false);
    });

    test('cannot logout if initialized', () {
      expect(
        /// what the code below is saying is that we should run the logout
        /// function and then test the function in the throwA stuff
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('description', () async {
      await provider.initialize();
      expect(provider.isInitialzed, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'should be able to intialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialzed, true);
      },
      timeout: const Timeout(Duration(seconds: 3)),
    );

    test('Create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'tolulope@bello.com',
        password: 'anypassword',
      );

      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );
      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'tolulopebello',
      );

      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );

      final user = await provider.createUser(
        email: 'tolulope',
        password: 'bello',
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialzed => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialzed) throw NotInitializedException();
    await Future.delayed(
      const Duration(seconds: 2),
    );
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialzed) throw NotInitializedException();
    if (email == 'tolulope@bello.com') throw UserNotFoundAuthException();
    if (password == 'tolulopebello') throw WrongPasswordAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: 'email',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialzed) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(
      const Duration(seconds: 2),
    );
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialzed) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      isEmailVerified: true,
      email: 'email',
    );
    _user = newUser;
  }
}
