
import 'package:excalci/constants/routes.dart';
import 'package:excalci/utilities/show_error_dialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log; 
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
      
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
                final UserCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email, 
                password: password
                );
                dev.log(UserCredential.toString());
                final user = UserCredential.user;
                if (user != null){
                  if (user.emailVerified==true){
                    dev.log("Email is verified!...");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      excalciRoute,
                      (_)=> false,
                      );
                  }
                  else{
                    dev.log("Email isn't verified!...");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (_)=> false,
                      );
                  }               
                }
                else{
                  dev.log("User is null");
                }
              } on FirebaseAuthException catch(e){
                dev.log(e.code);
                if (e.code== 'user-not-found'){
                  dev.log('No user found for that email');
                  await showErrorDialog(context, "No user found for that email");
                } else if (e.code== 'wrong-password' || e.code== 'invalid-credential'){
                  dev.log('Wrong password provided for that user');
                  await showErrorDialog(context, "Wrong username or password");
                }
                else{
                  dev.log("Sometihng went wrong!");
                  await showErrorDialog(context, "Something went wrong! Please try again later \n Error: ${e.code}");

                }
              }
              catch(e){
                dev.log(e.toString());
                await showErrorDialog(context, "Something went wrong! Please try again later \n Error: ${e.toString()}");
              }
      
                
            },
            child: const Text('Login')
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                   (route) => false
                   );
              },
             child: const Text("New User? Register here!"))
        ],
      ),
    );
  }
  
}
