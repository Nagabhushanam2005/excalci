
import 'package:excalci/app_theme.dart';
import 'package:excalci/constants/routes.dart';
import 'package:excalci/services/auth/auth_exceptions.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/utilities/dialogs/error_dialog.dart';
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
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: AppBar(
      //   title:  Text('Login',
      //   style: AppTheme.title,),
      
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .12),
              const Text(
                'Welcome,',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                'Sign in to continue!',
                style: TextStyle(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 188, 188, 188).withOpacity(.6),
                ),
              ),
              SizedBox(height: screenHeight * .12),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )
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
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final email =_email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().logIn(email: email, password: password);
                  final user = AuthService.firebase().currentUser;
                  if (user != null){
                    if (user.isEmailVerified==true){
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        excalciRoute,
                        (_)=> false,
                        );
                    }
                    else{
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (_)=> false,
                        );
                    }               
                  }

                } on UserNotFoundException catch(e){
                  await showErrorDialog(context, "No user found for that email");
                } on WrongPasswordException catch(e){
                  await showErrorDialog(context, "Wrong username or password");
                }  on GenericAuthException catch(e){
                  await showErrorDialog(context, "Something went wrong! Please try again later.");
                }
                catch(e){
                  await showErrorDialog(context,  "Something went wrong! Please try again later \n Error: ${e.toString()}");
                }
                   
              },
              child: Text('Login',
              style: AppTheme.button,)
              ),

              SizedBox(height: screenHeight*0.125,),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                     (route) => false
                     );
                },
              //  child: Text("New User? Register here!",
              //  style: AppTheme.button,))
              child: RichText(
                text: TextSpan(
                  text: 'New User? ',
                  style: TextStyle(
                    color: AppTheme.buttons,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Register here!',
                      style: TextStyle(
                        color: Color.fromARGB(255, 107, 33, 243),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ),
            
          ],
        ),
      ),
    );
  }
  
}
