import 'package:excalci/constants/routes.dart';
import 'package:excalci/utilities/show_error_dialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log; 
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final email =_email.text;
              final password = _password.text;
              try {
                final UserCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email, 
                  password: password
                  );
                  final user=FirebaseAuth.instance.currentUser;
                  user?.sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password'){
                  dev.log('The password provided is too weak.');
                  await showErrorDialog(context, "Weak password!...");
                } else if (e.code == 'email-already-in-use'){
                  dev.log('An account already exists for that email.');
                  await showErrorDialog(context, "An account already exists for that email.");
                }
                else if(e.code =='invalid-email'){
                  dev.log('The email provided is invalid.');
                  await showErrorDialog(context, "The email provided is invalid.");
                }
                else{
                  dev.log(e.code);
                  await showErrorDialog(context, "Something went wrong! \n ${e.code}");
              }
              } catch (e){
                dev.log(e.toString());
                await showErrorDialog(context, "Something went wrong! \n ${e.toString()}");
              }
                
            },
            child: const Text('Register')
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                 (route) => false
                 );
            }, 
            child: const Text("Already registered? Login here!") 
            )
        ],
      ),
    );
  }
}