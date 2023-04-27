import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// rn all we need from our auth user is to knwo whether he is verified or not

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromfirebase(User user) => AuthUser(
        isEmailVerified: user.emailVerified,
      );
}
