
import 'package:excalci/app_theme.dart';
import 'package:excalci/constants/routes.dart';
import 'package:excalci/enums/menu_actions.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/utilities/Widgets/bottom_nav_bar.dart';
import 'package:excalci/utilities/Widgets/tab_icon_data.dart';
import 'package:excalci/utilities/dialogs/logout_dialog.dart';
import 'package:excalci/views/excalci/accounts/excalci_accounts_view.dart';
// import 'package:excalci/views/excalci/excalci_add_expense_view.dart';
import 'package:excalci/views/excalci/budget_analysis/excalci_analysis_view.dart';
import 'package:excalci/views/excalci/home/excalci_home_view.dart';
import 'package:excalci/views/excalci/user/excalci_user_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

import 'package:flutter/widgets.dart';

class excalciView extends StatefulWidget {
  const excalciView({super.key});
  

  @override
  State<excalciView> createState() => _excalciViewState();
}
class _excalciViewState extends State<excalciView>with TickerProviderStateMixin  {

  String get userEmail => AuthService.firebase().currentUser!.email!;

  Widget internalBody=const excalciHomeView();
  String valueAppBar ='ExCalci';
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  
  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            dev.log('Add Clicked!');
            Navigator.of(context).pushNamed(excalciAddExpenseRoute);
            //disable the bottomBar
          },
          changeIndex: (int index) {
            dev.log(index.toString());
            if (index == 0) {
              setState(() {
                internalBody = const excalciHomeView();
                valueAppBar= 'ExCalci';
              });
              
            }
            else if(index == 1){
              setState(() {
                internalBody = const excalciAnalysisView();
                valueAppBar='Your Expenditure Analysis';
              });
              
            }
            else if(index == 2){
              setState(() {
                internalBody = const excalciAccountsView();
                valueAppBar='Accounts';
              });
            }
            else if(index == 3){
              setState(() {
                internalBody = const excalciUserView();
                valueAppBar='User';
              });
            }
          },
        ),
      ],
    );
  }

  Future<bool> waiter() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    return true;
  }

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    super.initState();
  }
  
  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;
    //get current route
    dev.log(isKeyboardOpen.toString());
    return Container(
      color: AppTheme.theme,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(valueAppBar),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                dev.log(value.toString());
                switch(value){
                  case MenuAction.logout:
                    final shouldLogout= await showLogOutDialog(context);
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
        body: FutureBuilder<bool>(
          future: waiter(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return Stack(
              children: <Widget> [
                internalBody,
                bottomBar(),
              ],
            );
          }
        ),
        // bottomNavigationBar: isKeyboardOpen? null: 
      ),
    );
  }
}


