import 'package:excalci/app_theme.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/services/cloud/cloud_expense.dart';
import 'package:excalci/services/cloud/firebase_cloud_storage.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions')
        ),
      body: Column(
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
                  dev.log(expenses.toString());
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: expenses.length,
                    itemBuilder: (context,index){
                      dev.log(expenses.length.toString());
                      final expense=expenses.elementAt(index);
                      //Green box for incomes
                      // grey box for expenses
                      if(expense.category=='Expense') {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                color: Color.fromARGB(169, 67, 67, 67),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTile(
                                  subtitle: Text(expense.desc.toString()),
                                  title: Text("₹"+expense.amount.toString()),
                                  trailing: Text(toDate(expense.date)),
                                  titleTextStyle:  AppTheme.income,
                                  subtitleTextStyle: AppTheme.desc,
                                  leadingAndTrailingTextStyle: AppTheme.date,

                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              //rounded container
                              Container(
                                // width: 800,
                                // height: 80,
                                decoration: BoxDecoration(
                                color: Color.fromARGB(169, 100, 152, 100),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTile(
                                  subtitle: Text(expense.desc.toString()),
                                  title: Text("₹"+expense.amount.toString()),
                                  trailing: Text(toDate(expense.date)),
                                  titleTextStyle:  AppTheme.income,
                                  subtitleTextStyle: AppTheme.desc,
                                  leadingAndTrailingTextStyle: AppTheme.date,

                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }
                return const Center(child: Text('No expenses found!'));
              },
            ),
            const SizedBox(height: 20,),
            
          ],
        ),
    );
  }
}