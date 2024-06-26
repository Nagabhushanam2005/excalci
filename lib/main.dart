// App to track budget and expenses.
import 'package:excalci/app_theme.dart';
import 'package:excalci/constants/routes.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/views/excalci/accounts/excalci_add_update_accounts_view.dart';
import 'package:excalci/views/excalci/home/excalci_add_update_expense_view.dart';
import 'package:excalci/views/excalci/budget_analysis/excalci_add_update_budget_view.dart';
import 'package:excalci/views/excalci/home/excalci_home_view.dart';
import 'package:excalci/views/excalci/home/excalci_see_all.dart';
import 'package:excalci/views/excalci/excalci_view.dart';
import 'package:excalci/views/login_view.dart';
import 'package:excalci/views/verify_email.dart';
import 'package:flutter/material.dart';
import 'views/register_view.dart';

 
void main() {

  // WidgetsFlutterBinding.ensureInitial
  // ized();
  runApp(MaterialApp(
        title: 'ExCalci',
        home: const HomePage(),
        theme: AppTheme.darkTheme,
        routes: {
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          verifyEmailRoute: (context) => const VerifyEmail(),
          excalciRoute:(context) => const excalciView(),
          excalciHomeRoute:(context) => const excalciHomeView(),
          excalciAddExpenseRoute:(context) => const excalciAddExpenseView(),
          excalciSeeAllRoute:(context) => const seeAll(),
          excalciAddBudgetRoute:(context) => const excalciAddBudgetView(),
          excalciAddAccountRoute:(context) => const excalciAddAccountView(),
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
              (user.toString());
              if (user != null){
                if (user.isEmailVerified==true){
                  return const excalciView();
                }
                else{
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
