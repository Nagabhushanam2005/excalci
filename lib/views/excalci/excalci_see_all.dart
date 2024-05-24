// ignore_for_file: unnecessary_const, camel_case_types

import 'package:excalci/app_theme.dart';
import 'package:excalci/constants/routes.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/services/cloud/cloud_expense.dart';
import 'package:excalci/services/cloud/firebase_cloud_storage.dart';
import 'package:excalci/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

class seeAll extends StatefulWidget {
  const seeAll({super.key});

  @override
  State<seeAll> createState() => _seeAllState();
}

class _seeAllState extends State<seeAll> {
  final String ownerUserId=AuthService.firebase().currentUser!.id!;
  final FirebaseCloudStorage _cloudService=FirebaseCloudStorage();

  
  String toDate(DateTime date){
    String k='';
    k='${date.year}-${date.month}-${date.day}';
    return k;
  }

  @override
  Widget build(BuildContext context) {
    final displayEI = context.getArgument<DisplayEI>();
    dev.log(displayEI!.expense.toString());
    dev.log(displayEI.income.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions')
        ),
      body: ListView(
          children: [
            const SizedBox(height: 20,),
            const Row(
              children: [
                const SizedBox(width: 10,),
                const Text('Your Recent Transactions:',style: TextStyle(fontSize: 20),),
                const SizedBox(width: 40,),
              ],
            ),
            // const SizedBox(height: 10,),
            StreamBuilder<Iterable<CloudExpense>>(
              stream: _cloudService.sortedExpenses(ownerUserId: ownerUserId),
              builder: (context,snapshot){
                
                if (snapshot.connectionState==ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError){
                  return const Center(child: Text('An error occurred!'));
                }
                if (snapshot.hasData){
                  final expenses=snapshot.data!;
                  return ListView.builder(
                    //disable scroll
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: expenses.length,
                    itemBuilder: (context,index){
                      
                      final expense=expenses.elementAt(index);
                      //Green box for incomes
                      // grey box for expenses
                      if(expense.category=='Expense' && displayEI.expense) {
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
                                  subtitle: Text(expense.desc.toString()),
                                  title: Text("₹${expense.amount}"),
                                  trailing: Text(toDate(expense.date)),
                                  titleTextStyle:  AppTheme.income,
                                  subtitleTextStyle: AppTheme.desc,
                                  leadingAndTrailingTextStyle: AppTheme.date,
                                  onTap: () {
                                    //pop up expense view
                                    Navigator.of(context).pushNamed(excalciAddExpenseRoute,arguments: expense);
                                  
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else if(expense.category=='Income' && displayEI.income){
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              //rounded container
                              Container(
                                // width: 800,
                                // height: 80,
                                decoration: BoxDecoration(
                                color: const Color.fromARGB(169, 100, 152, 100),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTile(
                                  subtitle: Text(expense.desc.toString()),
                                  title: Text("₹${expense.amount}"),
                                  trailing: Text(toDate(expense.date)),
                                  titleTextStyle:  AppTheme.income,
                                  subtitleTextStyle: AppTheme.desc,
                                  leadingAndTrailingTextStyle: AppTheme.date,
                                  onTap: () {
                                    //pop up expense view
                                    Navigator.of(context).pushNamed(excalciAddExpenseRoute,arguments: expense);
                                  
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox(height: 0,);
                    },
                  );
                }
                return const Center(child: Text('No expenses found!'));
              },
            ),
            const SizedBox(height: 80,),
            
          ],
        ),
    );
  }
}