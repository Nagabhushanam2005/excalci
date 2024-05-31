import 'package:excalci/constants/preferences_const.dart';
import 'package:excalci/constants/routes.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/services/cloud/cloud_accounts.dart';
import 'package:excalci/services/cloud/firebase_cloud_storage.dart';
import 'package:excalci/utilities/Widgets/bottom_popup_calculator.dart';
import 'package:excalci/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';



// Text(
//   "Your text",
//   style: TextStyle(
//     fontSize: 20.0,
//     color: Colors.red,
//     fontWeight: FontWeight.w600,
//   ),
// ),
class excalciAddAccountView extends StatefulWidget {
  const excalciAddAccountView({super.key});

  @override
  State<excalciAddAccountView> createState() => _excalciAddAccountViewState();
}


class _excalciAddAccountViewState extends State<excalciAddAccountView> {

  String ownerUserId=AuthService.firebase().currentUser!.id!;
  late final FirebaseCloudStorage _cloudService;
  CloudAccounts? _cloudAccounts;

  DateTime? selectedDate=DateTime.now();
  late final TextEditingController amt;
  double month=0;
  String currency='Rupee';
  IconData icon=Icons.currency_rupee_sharp;

  @override
  void initState() {
    _cloudService=FirebaseCloudStorage();
    amt=TextEditingController();
    super.initState();
    
  }
  


  Future<CloudAccounts> createOrGetAccounts(BuildContext context, DisplayAcc? editor) async{
    final widgetAccount = context.getArgument<Set>()?.last;
    SharedPreferences prefs=await SharedPreferences.getInstance();
        currency=prefs.getString('currencyFormat')??currency;
        icon=currencyName[prefs.getString('currencyFormatName')] ?? Icons.currency_rupee_sharp;
    if (widgetAccount != null) {
      _cloudAccounts = widgetAccount;
      if(editor!=null){
        if(editor.bank && !editor.cash) {
          amt.text = widgetAccount.Bank.values.elementAt(0).toString();
        }
        else if(editor.cash && !editor.bank) {
          amt.text = widgetAccount.Cash.values.elementAt(0).toString();
        }
      }
      return widgetAccount;
    }

    final existingAccount = _cloudAccounts;
    if (existingAccount != null) {
      return existingAccount;
    }
    final newAccount = await _cloudService.createAccounts(ownerUserId: ownerUserId);
    _cloudAccounts = newAccount;
    return newAccount;
  }

  void _deleteAccountIfEmpty() async{
    if(_cloudAccounts!=null && amt.text.isEmpty){
      await _cloudService.deleteAccount(documentId: _cloudAccounts!.documentId);
    }
  }

  void _saveAccountIfNotEmpty() async{
    if(_cloudAccounts!=null && amt.text.isNotEmpty){
      await _cloudService.updateBudget(documentId: _cloudAccounts!.documentId, budget: double.parse(amt.text), month: _cloudService.currentYYYYMM(),);
    }
  }

  void _updateAccountViewState() async{
    final editor = context.getArgument<Set>()?.first;
    if(_cloudAccounts==null){
      return;
    }
    if(_cloudAccounts!=null && amt.text.isNotEmpty){
      if(editor.bank){
        final bank={
          'Used amount': _cloudAccounts!.Bank['Used amount'],
          'balance': double.parse(amt.text),
          'txns': await _cloudService.transactionsInBank(ownerUserId: ownerUserId).first,
        };

        await _cloudService.updateAccounts(documentId: _cloudAccounts!.documentId, accountBank: bank, accountCash: _cloudAccounts!.Cash);
      }
      else{
        final cash={
          'used_amt': _cloudAccounts!.Cash['used_amt'],
          'balance': double.parse(amt.text),
          'txns':  await _cloudService.transactionsInCash(ownerUserId: ownerUserId).first,
        };
        await _cloudService.updateAccounts(documentId: _cloudAccounts!.documentId, accountBank: _cloudAccounts!.Bank, accountCash: cash); 
      } 
    }
  }
  void _setupListener() {
    amt.removeListener(_updateAccountViewState);
    amt.addListener(_updateAccountViewState);
  }

  @override
  void dispose() {
    amt.dispose();
    _deleteAccountIfEmpty();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final editor = context.getArgument<Set>()?.first;
      return Scaffold(
        appBar: AppBar(
          title: Text('${editor!.bank?'Bank':'Cash'} Account'),
        ),
        body:FutureBuilder(
          future: createOrGetAccounts(context,editor),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupListener();

                return Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ListView(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Icon(
                                        icon,
                                        size: 35,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller: amt,
                                          decoration: const InputDecoration(
                                            labelText: 'Balance...',
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      //calculator
                                      IconButton(
                                        onPressed: () async {
                                            await showBottomPopupCalculator(context);
                                          },
                                        icon: const Icon(Icons.calculate_rounded,
                                          size: 30,
                                          ),
                                      ),
                      
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                          
                      );

              default:
                return const CircularProgressIndicator();
            }
          },
        ),
        

      );
    }

}
