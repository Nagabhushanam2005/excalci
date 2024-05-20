import 'dart:async';
import 'package:excalci/services/auth/auth_user.dart';

abstract class AuthProvider{
  Future<void> initializeApp();
  AuthUser ? get currentUser;

  Future<AuthUser?> logIn({required email, required String password});
  Future<AuthUser?> register({required email, required String password});
  Future<void> logOut();
  Future<void> verifyEmail();

}