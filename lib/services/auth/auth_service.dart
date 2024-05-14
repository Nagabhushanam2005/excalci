import 'package:excalci/services/auth/auth_provider.dart';
import 'package:excalci/services/auth/auth_user.dart';

class AuthService implements AuthProvider{
  final AuthProvider authProvider;

  AuthService({required this.authProvider});
  
  @override
  AuthUser? get currentUser =>authProvider.currentUser;
  
  @override
  Future<AuthUser?> logIn({required email, required String password,}) => authProvider.logIn(email: email, password: password);
  
  @override
  Future<void> logOut() => authProvider.logOut();
  
  @override
  Future<AuthUser?> register({required email, required String password,}) => authProvider.register(email: email, password: password);
  
  @override
  Future<void> verifyEmail() => authProvider.verifyEmail();
}