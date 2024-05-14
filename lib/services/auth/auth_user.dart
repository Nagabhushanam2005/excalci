import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
@immutable
class AuthUser {
  // final User? user;
  final bool isEmailVerified;

  const AuthUser(this.isEmailVerified);
  factory AuthUser.fromFirebase(User user) =>AuthUser(user.emailVerified);
}