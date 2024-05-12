
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
                      '/excalci/',
                      (_)=> false,
                      );
                  }
                  else{
                    dev.log("Email isn't verified!...");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/verify_email/',
                      (_)=> false,
                      );
                  }               
                }
                else{
                  dev.log("User is null");
                }
              } on FirebaseAuthException catch(e){
                if (e.code== 'user-not-found'){
                  dev.log('No user found for that email');
                } else if (e.code== 'wrong-password'){
                  dev.log('Wrong password provided for that user');
                
                }
                else{
                  dev.log("Sometihng went wrong!");
                  dev.log(e.runtimeType.toString());
                  dev.log(e.toString());
                }
              }
      
                
            },
            child: const Text('Login')
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/register/',
                   (route) => false
                   );
              },
             child: const Text("New User? Register here!"))
        ],
      ),
    );
  }
  
}

