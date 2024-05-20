import 'package:excalci/constants/routes.dart';
import 'package:excalci/services/auth/auth_exceptions.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/utilities/dialogs/error_dialog.dart';
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
                AuthService.firebase().register(email: email, password: password);
                  AuthService.firebase().verifyEmail();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordException {
                dev.log('The password provided is too weak.');
                await showErrorDialog(context, "Weak password!...");
              } on EmailInUseException {
                dev.log('An account already exists for that email.');
                await showErrorDialog(context, "An account already exists for that email.");
              } on InvalidEmailException {
                dev.log('The email provided is invalid.');
                await showErrorDialog(context, "The email provided is invalid.");
              } on GenericAuthException catch(e){
                dev.log('Something went wrong! \n ${e.toString()}');
                await showErrorDialog(context, "Something went wrong! Try again.}");
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