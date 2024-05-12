
import 'package:excalci/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context,snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return Column(
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
                  TextButton(
                    onPressed: () async {
                      final email =_email.text;
                      final password = _password.text;
                      try {
                        final UserCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, 
                        password: password
                        );
                      } on FirebaseAuthException catch(e){
                        if (e.code== 'user-not-found'){
                          print('No user found for that email');
                        } else if (e.code== 'wrong-password'){
                          print('Wrong password provided for that user');
                        
                        }
                        else{
                          print("Sometihng went wrong!");
                          print(e.runtimeType);
                          print(e);
                        }
                      }

                        
                    },
                    child: const Text('Login')
                    ),
                ],
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
          
        }
        
      )
    );
  }
  
}

