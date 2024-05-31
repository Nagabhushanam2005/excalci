import 'package:excalci/app_theme.dart';
import 'package:excalci/constants/routes.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/services/cloud/cloud_accounts.dart';
import 'package:excalci/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';

class excalciAccountsView extends StatefulWidget {
  const excalciAccountsView({super.key});

  @override
  State<excalciAccountsView> createState() => _excalciAccountsViewState();
}

class _excalciAccountsViewState extends State<excalciAccountsView> {
  final _cloudService=FirebaseCloudStorage();
  final String? ownerUserId=AuthService.firebase().currentUser?.id;
  String currency='₹';

  @override
  void initState() {
    SharedPreferences.getInstance()
    .then((prefs) {
      setState(() {
        currency=prefs.getString('currencyFormat')?? currency;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Center(
        child: Column(
          children: [
            
            const SizedBox(height: 20,),
            Row(
              children: [
                const SizedBox(width: 10,),
                Text('Your account:',style: AppTheme.title,),
                const SizedBox(width: 20,),
                
              ],
            ),
            // const SizedBox(height: 10,),
            Row(
              children: [
                const SizedBox(width: 15,),
                SizedBox(
                  width: 180,
                  child: StreamBuilder<Iterable<CloudAccounts>>(
                    stream: _cloudService.allAccounts(ownerUserId: ownerUserId!),
                    builder: (context,snapshot){
                      if (snapshot.connectionState==ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError){
                        return const Center(child: Text('An error occurred!'));
                      }
                      if (!snapshot.data!.isEmpty){
                        final expenses=snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context,index){
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                      color: const Color.fromARGB(169, 67, 67, 67),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: ListTile(
                                        subtitle: const Text("Bank"),
                                        title: Text("$currency ${expenses.first.Bank.values.elementAt(0)}"),
                                        titleTextStyle:  AppTheme.title,
                                        subtitleTextStyle: AppTheme.income,
                                        onTap: () {
                                          DisplayAcc acc=DisplayAcc(bank: true, cash: false);
                                          Navigator.pushNamed(context, excalciAddAccountRoute,arguments: {acc,expenses.first});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            
                          },
                        );
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context,index){
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                      color: const Color.fromARGB(169, 67, 67, 67),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: ListTile(
                                        subtitle: const Text("Bank"),
                                        title: Text("$currency 0.0"),
                                        
                                        titleTextStyle:  AppTheme.title,
                                        subtitleTextStyle: AppTheme.income,
                                        onTap: () {
                                          DisplayAcc acc=DisplayAcc(bank: true, cash: false);
                                          Navigator.pushNamed(context, excalciAddAccountRoute,arguments: {acc,null});

                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            
                          },
                        );
                    },
                  ),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 180,
                  child: StreamBuilder<Iterable<CloudAccounts>>(
                    stream: _cloudService.allAccounts(ownerUserId: ownerUserId!),
                    builder: (context,snapshot){
                      if (snapshot.connectionState==ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError){
                        return const Center(child: Text('An error occurred!'));
                      }
                      if (snapshot.data!.isNotEmpty){
                        final expenses=snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context,index){
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                      color: const Color.fromARGB(169, 67, 67, 67),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: ListTile(
                                        subtitle: const Text("Cash"),
                                        title: Text("$currency ${expenses.first.Cash.values.elementAt(0)}"),
                                        titleTextStyle:  AppTheme.title,
                                        subtitleTextStyle: AppTheme.income,
                                        onTap: () {
                                          DisplayAcc acc=DisplayAcc(bank: false, cash: true);
                                          Navigator.pushNamed(context, excalciAddAccountRoute,arguments: {acc,expenses.first});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            
                          },
                        );
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context,index){
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                      color: const Color.fromARGB(169, 67, 67, 67),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: ListTile(
                                        subtitle: const Text("Cash"),
                                        title: Text("$currency 0.0"),
                                        
                                        titleTextStyle:  AppTheme.title,
                                        subtitleTextStyle: AppTheme.income,
                                        onTap: () {
                                          DisplayAcc acc=DisplayAcc(bank: false, cash: true);
                                          Navigator.pushNamed(context, excalciAddAccountRoute,arguments: {acc,null});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            
                          },
                        );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            
          ],
        ),
        );
  }
  
}