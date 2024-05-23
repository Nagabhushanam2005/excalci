// App to track budget and expenses.
import 'package:excalci/constants/routes.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/views/excalci/excalci_add_expense_view.dart';
import 'package:excalci/views/excalci/excalci_add_update_budget_view.dart';
import 'package:excalci/views/excalci/excalci_home_view.dart';
import 'package:excalci/views/excalci/excalci_see_all.dart';
import 'package:excalci/views/excalci/excalci_view.dart';
import 'package:excalci/views/login_view.dart';
import 'package:excalci/views/verify_email.dart';
import 'package:flutter/material.dart';
import 'views/register_view.dart';
import 'dart:developer'as dev show log;
 
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
        title: 'ExCalci',
        theme: ThemeData(
          //Dark theme
          brightness: Brightness.dark,
          primaryColor: Colors.deepPurple,
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

          useMaterial3: true,
        ),
        home: const HomePage(),
        routes: {
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          verifyEmailRoute: (context) => const VerifyEmail(),
          excalciRoute:(context) => const excalciView(),
          excalciHomeRoute:(context) => const excalciHomeView(),
          excalciAddExpenseRoute:(context) => const excalciAddExpenseView(),
          excalciSeeAllRoute:(context) => const seeAll(),
          excalciAddBudgetRoute:(context) => const excalciAddBudgetView(),
        },
      ),
    
    );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

   @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initializeApp(),
        builder: (context,snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              final user=AuthService.firebase().currentUser;
              dev.log(user.toString());
              if (user != null){
                if (user.isEmailVerified==true){
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
              return const Center(child: CircularProgressIndicator());
          }
          
        }
        
      );
  }
}


