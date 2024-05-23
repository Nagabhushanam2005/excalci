import 'package:excalci/app_theme.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/services/cloud/cloud_accounts.dart';
import 'package:excalci/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'dart:developer'as dev show log;

class excalciAccountsView extends StatefulWidget {
  const excalciAccountsView({super.key});

  @override
  State<excalciAccountsView> createState() => _excalciAccountsViewState();
}

class _excalciAccountsViewState extends State<excalciAccountsView> {
  final _cloudService=FirebaseCloudStorage();
  final String? ownerUserId=AuthService.firebase().currentUser?.id;



  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            TextButton(onPressed: (){
              //add an account
              _cloudService.createAccounts(ownerUserId: ownerUserId!);
              dev.log(_cloudService.allAccounts(ownerUserId: ownerUserId!).toString());
            }, child: Text('Add Account')),
            StreamBuilder<Iterable<CloudAccounts>>(
              stream: _cloudService.allAccounts(ownerUserId: ownerUserId!),
              builder: (context,snapshot){
                if (snapshot.connectionState==ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError){
                  return const Center(child: Text('An error occurred!'));
                }
                if (snapshot.hasData){
                  final accounts=snapshot.data!;
                  dev.log(accounts.toString());
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: accounts.length,
                    itemBuilder: (context,index){
                      final account=accounts.elementAt(index);
                      return Column(
                        children: [
                          const SizedBox(width: 20,),
                          Text(account.Bank.toString()),
                          const SizedBox(width: 20,),
                          Text(account.Cash.toString()),
                        ],
                      );
                    }
                  );
                }
                return const Center(child: Text('No incomes found!'));
              },
              
              )
          ],
        )

      );
  }
  
}