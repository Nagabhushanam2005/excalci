// App to track budget and expenses.
import 'package:excalci/firebase_options.dart';
import 'package:excalci/views/login_view.dart';
import 'package:excalci/views/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/register_view.dart';
 
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
        routes: {
          '/login/': (context) => const LoginView(),
          '/register/': (context) => const RegisterView(),
        
        },
      ),
    
    );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

   @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context,snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              final user=FirebaseAuth.instance.currentUser;
              print(user);
              if (user != null){
                if (user?.emailVerified == false){
                  print("Email isn't verified!...");
                  return const VerifyEmail();
                }
                else{
                  print("Email is verified!...");
                }
                // return const LoginView();
              }
              else{
                return const LoginView();
              }
              return const Text('done...');
            default:
              return const Center(child: const CircularProgressIndicator());
          }
          
        }
        
      );
  }
}

