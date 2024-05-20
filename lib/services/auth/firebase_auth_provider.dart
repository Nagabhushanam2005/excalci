//import all files in auth
import 'package:excalci/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart'
  show FirebaseAuth ,FirebaseAuthException;
import 'package:excalci/services/auth/auth_exceptions.dart';
import 'package:excalci/services/auth/auth_provider.dart';
import 'package:excalci/services/auth/auth_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as dev show log;
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
        if (e.code.toString()== 'user-not-found'){
          throw UserNotFoundException();
        } else if (e.code.toString()== 'wrong-password' || e.code.toString()== 'invalid-credential'){
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
      dev.log(e.code.toString());
      if (e.code.toString() == 'weak-password'){
        throw WeakPasswordException();
      } else if (e.code.toString() == 'email-already-in-use'){
        throw EmailInUseException();
      }
      else if(e.code.toString() =='invalid-email'){
        throw InvalidEmailException();
      }
      else{
        // dev.log(e.code.toString());
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
  
  @override
  Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

}