// App to track budget and expenses.
import 'package:excalci/constants/routes.dart';
import 'package:excalci/firebase_options.dart';
import 'package:excalci/views/login_view.dart';
import 'package:excalci/views/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/register_view.dart';
import 'dart:developer'as dev show log;
 
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
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          verifyEmailRoute: (context) => const VerifyEmail(),
          excalciRoute:(context) => const excalciView(),
        
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
              dev.log(user.toString());
              if (user != null){
                if (user.emailVerified==true){
                  dev.log("Email is verified!...");
                  return const excalciView();
                }
                else{
                  dev.log("Email isn't verified!...");
                  return const VerifyEmail();
                }               
              }
              else{
                return const LoginView();
              }
            default:
              return const Center(child: const CircularProgressIndicator());
          }
          
        }
        
      );
  }
}


enum MenuAction { logout }

class excalciView extends StatefulWidget {
  const excalciView({super.key});

  @override
  State<excalciView> createState() => _excalciViewState();
}
class _excalciViewState extends State<excalciView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExCalci'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              dev.log(value.toString());
              switch(value){
                case MenuAction.logout:
                  final shouldLogout= await logoutDialog(context);
                  dev.log(shouldLogout.toString());
                  if (shouldLogout){
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_)=> false,
                      );
                  }
                  
                  break;
              }

            },
            itemBuilder: (context){
              return [
                const PopupMenuItem(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            }
          )
        ],
      ),
      body: const Center(
        child: Text('Welcome to excalci!'),
      ),
    );
  }
}

Future<bool> logoutDialog(BuildContext context){
  return showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout"),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(true);
            },
            child: const Text('Logout'),
          ),
        ],
      );
    }
    ).then((value) => value ?? false,);
}