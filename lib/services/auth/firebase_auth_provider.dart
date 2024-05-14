//import all files in auth
import 'package:firebase_auth/firebase_auth.dart'
  show FirebaseAuth ,FirebaseAuthException;
import 'package:excalci/services/auth/auth_exceptions.dart';
import 'package:excalci/services/auth/auth_provider.dart';
import 'package:excalci/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider{
  @override
  AuthUser? get currentUser {
    final user= FirebaseAuth.instance.currentUser;
    if (user != null){
      return AuthUser.fromFirebase(user);
    }
    return null;
  }

  @override
  Future<AuthUser?> logIn({
    required email,
    required String password
    }) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      final user=currentUser;
      if (user == null){
        throw UserNotLoggedException();
      }
      return user;

    } on FirebaseAuthException catch(e){
        if (e.code== 'user-not-found'){
          throw UserNotFoundException();
        } else if (e.code== 'wrong-password' || e.code== 'invalid-credential'){
          throw WrongPasswordException();
        }
        else{
          throw GenericAuthException();
        }

    }
    catch(e){
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user=FirebaseAuth.instance.currentUser;
    if (user != null){
      await FirebaseAuth.instance.signOut();
    }
    else{
      throw UserNotLoggedException();
    }
  }

  @override
  Future<AuthUser?> register({
    required email,
    required String password
   }) async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      final user=currentUser;
      if (user == null){
        throw UserNotLoggedException();
      }
      return user;
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password'){
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use'){
        throw EmailInUseException();
      }
      else if(e.code =='invalid-email'){
        throw InvalidEmailException();
      }
      else{
        // dev.log(e.code);
        throw GenericAuthException();
    }
    } catch (e){
      // dev.log(e.toString());
      throw GenericAuthException();
    }
  }

  @override
  Future<void> verifyEmail() async{
    final user= FirebaseAuth.instance.currentUser;
    if (user != null){
      await user.sendEmailVerification();
    }
    else{
      throw UserNotLoggedException();
    }
  }

}