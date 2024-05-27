import 'package:excalci/app_theme.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/services/cloud/cloud_budget.dart';
import 'package:excalci/services/cloud/firebase_cloud_storage.dart';
import 'package:excalci/utilities/Widgets/bottom_popup_calculator.dart';
import 'package:excalci/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;



// Text(
//   "Your text",
//   style: TextStyle(
//     fontSize: 20.0,
//     color: Colors.red,
//     fontWeight: FontWeight.w600,
//   ),
// ),
class excalciAddBudgetView extends StatefulWidget {
  const excalciAddBudgetView({super.key});

  @override
  State<excalciAddBudgetView> createState() => _excalciAddBudgetViewState();
}


class _excalciAddBudgetViewState extends State<excalciAddBudgetView> {

  String ownerUserId=AuthService.firebase().currentUser!.id!;
  late final FirebaseCloudStorage _cloudService;
  CloudBudget? _cloudBudget;

  DateTime? selectedDate=DateTime.now();
  late final TextEditingController amt;
  double month=0;

  @override
  void initState() {
    _cloudService=FirebaseCloudStorage();
    amt=TextEditingController();
    super.initState();
  }
  


  Future<CloudBudget> createOrGetBudget(BuildContext context) async{
    final widgetBudget = context.getArgument<CloudBudget>();
    if (widgetBudget != null) {
      _cloudBudget = widgetBudget;
      amt.text = widgetBudget.budget.toString();
      month=widgetBudget.month;
      return widgetBudget;
    }

    final existingBudget = _cloudBudget;
    if (existingBudget != null) {
      return existingBudget;
    }

    final newBudget = await _cloudService.createBudget(ownerUserId: ownerUserId,budget: 0.0,month: _cloudService.currentYYYYMM());
    _cloudBudget = newBudget;
    return newBudget;
  }

  void _deleteBudgetIfEmpty() async{
    if(_cloudBudget!=null && amt.text.isEmpty){
      await _cloudService.deleteBudget(documentId: _cloudBudget!.documentId);
    }
  }

  void _saveBudgetIfNotEmpty() async{
    if(_cloudBudget!=null && amt.text.isNotEmpty){
      await _cloudService.updateBudget(documentId: _cloudBudget!.documentId, budget: double.parse(amt.text), month: _cloudService.currentYYYYMM(),);
    }
  }

  void _updateBudgetViewState() async{
    if(_cloudBudget==null){
      return;
    }
    if(_cloudBudget!=null && amt.text.isNotEmpty){
      await _cloudService.updateBudget(documentId: _cloudBudget!.documentId, budget: double.parse(amt.text), month: _cloudService.currentYYYYMM(),);

    }
  }
  void _setupListener() {
    amt.removeListener(_updateBudgetViewState);
    amt.addListener(_updateBudgetViewState);
  }

  @override
  void dispose() {
    amt.dispose();
    _deleteBudgetIfEmpty();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    void getDate() async{
      if(month!=0.0){
         selectedDate=DateTime.parse('${month.toString().substring(0,4)}-${month.toString().substring(4,6)}-01');
         dev.log(selectedDate.toString());
         return;
      }
      final DateTime? picked=await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(2000),
        lastDate: DateTime(2051),
      );
      if (picked!=null && picked!=selectedDate){
        setState(() {
          selectedDate=picked;
        });
      }
    }

    String toMonth(DateTime date){
      String k='';
      k='${date.year}-${date.month}';
      return k;
    }

    double toYYYYMM(DateTime date){
      return double.parse('${date.year}${date.month}');
    }



    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget of the month'),
      ),
      body:FutureBuilder(
        future: createOrGetBudget(context),
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
                                    Text(
                                      "Month:",
                                      style: AppTheme.subtitle,
                                    ),
                                    const SizedBox(width: 10),
                                    
                                    //arrow button
                                    TextButton(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.calendar_month,
                                            size: 35,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(toMonth(selectedDate!),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          const SizedBox(width: 40),
                                          
                                        ],
                                      ),
                                      onPressed: getDate,
                                      
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.currency_rupee_sharp,
                                      size: 35,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: amt,
                                        decoration: const InputDecoration(
                                          labelText: 'Budget',
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

                                
                    
                                //choose mode of payment
                    
                    
                                const SizedBox(height: 40,),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // add expense
                                        _updateBudgetViewState();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Add Budget'),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width/4+20),
                                    ElevatedButton(
                                      onPressed: () {
                                        // cancel
                                        _cloudBudget=null;
                                        _deleteBudgetIfEmpty();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
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
