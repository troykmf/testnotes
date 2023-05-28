import 'package:flutter/material.dart' show immutable;
import 'package:testnotes/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

// class AuthStateLoading extends AuthState {
//   const AuthStateLoading();
// }

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

// class AuthStateLoginFailure extends AuthState {
//   final Exception exception;
//   const AuthStateLoginFailure(this.exception);
// }

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

// the reason for the loadingText is because we might have a custom
// loading text for AuthStateLoggedOut
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  // final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );
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
