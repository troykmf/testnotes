import 'package:flutter/material.dart' show immutable;
import 'package:testnotes/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

// class AuthStateLoading extends AuthState {
//   const AuthStateLoading();
// }

class AuthStateOninitialized extends AuthState {
  const AuthStateOninitialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

// class AuthStateLoginFailure extends AuthState {
//   final Exception exception;
//   const AuthStateLoginFailure(this.exception);
// }

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });
// the reason we're creating this equatable mixin is to get various
// mutations of logout like becuse the about class is producing at least 3
// diiferent kind of scenerios
// 1.Logout with exception null isLoading false
// 2. Logout with exception null isLoading true
// 3. Logout with exception isLoading false
  @override
  List<Object?> get props => [exception, isLoading];
}

// class AuthStateLogOutFailure extends AuthState {
//   final Exception exception;
//   const AuthStateLogOutFailure(this.exception);
// }
