import 'auth_user.dart';

abstract class AuthProvider{
  AuthUser ? get currentUser;

  Future<AuthUser?> logIn({required email, required String password});
  Future<AuthUser?> register({required email, required String password});
  Future<void> logOut();
  Future<void> verifyEmail();
  
}