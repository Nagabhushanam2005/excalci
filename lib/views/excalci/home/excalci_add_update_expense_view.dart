import 'package:excalci/app_theme.dart';
import 'package:excalci/constants/preferences_const.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/services/cloud/cloud_expense.dart';
import 'package:excalci/services/cloud/cloud_storage_constants.dart';
import 'package:excalci/services/cloud/firebase_cloud_storage.dart';
import 'package:excalci/utilities/Widgets/bottom_popup_calculator.dart';
import 'package:excalci/utilities/Widgets/bottom_single_select.dart';
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
class excalciAddExpenseView extends StatefulWidget {
  const excalciAddExpenseView({super.key});

  @override
  State<excalciAddExpenseView> createState() => _excalciAddExpenseViewState();
}


class _excalciAddExpenseViewState extends State<excalciAddExpenseView> {

  String ownerUserId=AuthService.firebase().currentUser!.id!;
  late final FirebaseCloudStorage _cloudService;
  CloudExpense? _cloudExpense;

  List<bool> isSelected=[true,false];
  Map<String,IconData> categories=categoryExpenseDefault;
  Map<String,IconData> acc_items=modeItems;
  String selectedCategory='Choose';
  String selectedAccount='Cash';
  String modeString="Mode of payment:";
  
  DateTime? selectedDate=DateTime.now();
  late final TextEditingController amt;
  late final TextEditingController desc;
  String? category;
  String currency='';
  IconData icon=Icons.currency_rupee_sharp;
  String defaultMode='Cash';

  @override
  void initState() {
    _cloudService=FirebaseCloudStorage();
    amt=TextEditingController();
    desc=TextEditingController();
    super.initState();
   
  }
  


  Future<CloudExpense> createOrGetExpense(BuildContext context) async{
    CloudExpense? widgetExpense = context.getArgument<CloudExpense>();
    SharedPreferences prefs=await SharedPreferences.getInstance();
        currency=prefs.getString('currencyFormat')??currency;
        icon=currencyName[prefs.getString('currencyFormatName')] ?? Icons.currency_rupee_sharp;
        selectedAccount=prefs.getString('defaultMode')??defaultMode;
    if (widgetExpense != null) {
      _cloudExpense = widgetExpense;
      amt.text = widgetExpense.amount.toStringAsFixed(2);
      desc.text = widgetExpense.desc;
      selectedDate = widgetExpense.date;
      selectedAccount=widgetExpense.account;
      selectedCategory=widgetExpense.useCategory;
      category=widgetExpense.category;
      if (category=='Expense'){
        isSelected=[true,false];
        modeString='Mode of payment:';
        categories=categoryExpenseDefault;
      }
      else{
        isSelected=[false,true];
        modeString='Mode of reciept:';
        categories=categoryIncomeDefault;
      }
      return widgetExpense;
    }

    CloudExpense? existingNote = _cloudExpense;
    if (existingNote != null) {
      return existingNote;
    }

    CloudExpense newNote = await _cloudService.createNewExpense(ownerUserId: ownerUserId);
    _cloudExpense = newNote;
    return newNote;
  }


  void _deleteExpenseIfEmpty(){
    if(_cloudExpense!=null && amt.text.isEmpty && desc.text.isEmpty){
      _cloudService.deleteExpense(documentId: _cloudExpense!.documentId);
    }
  }

  void _updateExpenseViewState() async{
    if(_cloudExpense==null){
      return;
    }
    if(_cloudExpense!=null && amt.text.isNotEmpty && desc.text.isNotEmpty){
      await _cloudService.updateExpense(
        documentId: _cloudExpense!.documentId,
        category: category ?? 'Expense',
        account: selectedAccount,
        amount: double.parse(amt.text==''?'0':amt.text),
        date: selectedDate!,
        desc: desc.text,
        currency: currency,
        useCategory: selectedCategory,
      );
    }
  }
  void _setupListener() {
    amt.removeListener(_updateExpenseViewState);
    amt.addListener(_updateExpenseViewState);
    desc.removeListener(_updateExpenseViewState);
    desc.addListener(_updateExpenseViewState);
  }

  @override
  void dispose() {
    amt.dispose();
    desc.dispose();
    _deleteExpenseIfEmpty();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
    void onSelected(String value){
      setState(() {
        selectedCategory=value;
      });
    }

    void getDate() async{
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

    String toDate(DateTime date){
      String k='';
      k='${date.year}-${date.month}-${date.day}';
      return k;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body:FutureBuilder(
        future: createOrGetExpense(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupListener();
              return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width/4),
                          child: ToggleButtons(
                            renderBorder: true,
                            borderColor: Colors.black,
                            borderWidth: 0.5,
                            borderRadius: BorderRadius.circular(10),
                            
                            isSelected: isSelected,
                            onPressed: (int newIndex) {
                              // change category
                              setState(() {
                                if (newIndex==0){
                                  isSelected=[true,false];
                                  category='Expense';
                                  modeString='Mode of payment:';
                                  categories=categoryExpenseDefault;
                                }
                                else{
                                  isSelected=[false,true];
                                  category='Income';
                                  modeString='Mode of reciept:';
                                  categories=categoryIncomeDefault;
                                }
                              });
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('Expense', style: TextStyle(fontSize: 18)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('Income', style: TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                        ),
                    
                        
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListView(
                              children: <Widget>[
                                
                                TextField(
                                  //keyborad overdraws the app
                                  controller: desc,
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                  ),
                                  maxLength: 200,
                    
                                ),
                                
                                Row(
                                  children: [
                                    Icon(
                                      icon,
                                      size: 35,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: amt,
                                        decoration: const InputDecoration(
                                          labelText: 'Amount',
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
                                //choose category bottom sheet
                                
                                Row(
                                  children: [
                                    Text(
                                      "Category:",
                                      style: AppTheme.subtitle,
                                    ),
                                    const SizedBox(width: 10),
                                    
                                    //arrow button
                                    TextButton(
                                      onPressed: () async {
                                        await showBottomSingleSelect<String>(
                                          context: context,
                                          items: categories,
                                          title: 'Choose Category',
                                          onSelected: onSelected,
                                          selectedValue: selectedCategory,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(categories[selectedCategory],
                                            size: 35,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(selectedCategory,
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          const SizedBox(width: 40),
                                          
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                    
                                
                                
                    
                    
                    
                                //choose account
                                Row(
                                  children: [
                                     Text(
                                      modeString,
                                      style:  AppTheme.subtitle,
                                    ),
                                    const SizedBox(width: 10),
                                    
                                    //arrow button
                                    TextButton(
                                      onPressed: () async {
                                        await showBottomSingleSelect<String>(
                                          context: context,
                                          items: acc_items,
                                          title: 'Choose mode',
                                          onSelected: (String value){
                                            setState(() {
                                              selectedAccount=value;
                                            });
                                          },
                                          selectedValue: selectedAccount,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(acc_items[selectedAccount],
                                            size: 35,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(selectedAccount,
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          // const SizedBox(width: 40),
                                          
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                //choose date
                    
                                Row(
                                  children: [
                                    Text(
                                      "Date:",
                                      style: AppTheme.subtitle,
                                    ),
                                    const SizedBox(width: 10),
                                    
                                    //arrow button
                                    TextButton(
                                      onPressed: getDate,
                                      child: Row(
                                        children: [
                                          const Icon(Icons.calendar_month,
                                            size: 35,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(toDate(selectedDate!),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          const SizedBox(width: 40),
                                          
                                        ],
                                      ),
                                      
                                    ),
                                  ],
                                ),
                    
                                //choose mode of payment
                    
                    
                    
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // add expense
                                        _updateExpenseViewState();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Add Expense'),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width/4+20),
                                    ElevatedButton(
                                      onPressed: () async{
                                        // cancel

                                        await _cloudService.deleteExpense(documentId: _cloudExpense!.documentId);
                                        // _cloudExpense=null;
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
