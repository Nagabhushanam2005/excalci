
import 'package:excalci/constants/routes.dart';
import 'package:excalci/enums/menu_actions.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;


class excalciView extends StatefulWidget {
  const excalciView({super.key});

  @override
  State<excalciView> createState() => _excalciViewState();
}
class _excalciViewState extends State<excalciView> {

  String get userEmail => AuthService.firebase().currentUser!.email!;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
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
                    await AuthService.firebase().logOut();
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