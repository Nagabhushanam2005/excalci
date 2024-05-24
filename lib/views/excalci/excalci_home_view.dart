

import 'package:excalci/app_theme.dart';
import 'package:excalci/constants/routes.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/services/cloud/cloud_budget.dart';
import 'package:excalci/services/cloud/cloud_expense.dart';
import 'package:excalci/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;
import 'package:getwidget/getwidget.dart';

 
//displays the user name
// displays the users expenses total and income total
//display % bar of budget used
// displays the last 5 transactions done
class excalciHomeView extends StatefulWidget {
  const excalciHomeView({super.key});

  @override
  State<excalciHomeView> createState() => _excalciHomeViewState();
}

class _excalciHomeViewState extends State<excalciHomeView> {

  String ownerUserId=AuthService.firebase().currentUser!.id!;
  late final FirebaseCloudStorage _cloudService;
  double expense=0;
  double budget=1;
  double percent=0.0;


  @override
  void initState() {
    _cloudService=FirebaseCloudStorage();
    super.initState();
  }


  @override
  Widget build(BuildContext context)  {
    // return all expenses in LIGHT RED, incomes in green
    String toDate(DateTime date){
      String k='';
      k='${date.year}-${date.month}-${date.day}';
      return k;
    }
    //get percent used

    var displayEI=DisplayEI(
      income: true,
      expense: true
    );

    return  ListView(
      children: [
        //monthly overview
        Column(
          children: [
            const SizedBox(height: 20,),
            Row(
              children: [
                const SizedBox(width: 10,),
                Text('Monthly Overview:',style: AppTheme.title,),
                const SizedBox(width: 20,),
                
              ],
            ),
            // const SizedBox(height: 10,),
            Row(
              children: [
                const SizedBox(width: 15,),
                SizedBox(
                  width: 180,
                  child: StreamBuilder<double>(
                    stream: _cloudService.amountSpentOverMonth(ownerUserId: ownerUserId),
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
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context,index){
                            expense=expenses;

                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                      color: const Color.fromARGB(169, 216, 77, 77),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: ListTile(
                                        subtitle: const Text("Spent"),
                                        title: Text("₹ $expense"),
                                        titleTextStyle:  AppTheme.title,
                                        subtitleTextStyle: AppTheme.expense,
                                        onTap: () {
                                          var displayEI=DisplayEI(
                                            income: true,
                                            expense: true
                                          );
                                          displayEI.expense=true;
                                          displayEI.income=false;
                                          Navigator.of(context).pushNamed(excalciSeeAllRoute,arguments: displayEI);
                                        
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
                                      color: const Color.fromARGB(169, 216, 77, 77),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: ListTile(
                                        subtitle: const Text("Spent"),
                                        title: const Text("₹ 0.0"),
                                        titleTextStyle:  AppTheme.title,
                                        subtitleTextStyle: AppTheme.expense,
                                        onTap: () {
                                          var displayEI=DisplayEI(
                                            income: true,
                                            expense: true
                                          );
                                          displayEI.expense=true;
                                          displayEI.income=false;
                                          Navigator.of(context).pushNamed(excalciSeeAllRoute,arguments: displayEI);
                                  
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
                SizedBox(
                  width: 180,
                  child: StreamBuilder<double>(
                    stream: _cloudService.amountIncomeOverMonth(ownerUserId: ownerUserId),
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
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context,index){
                            final expense=expenses;
                            //Green box for incomes
                            // grey box for expenses
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(169, 77, 216, 86),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: ListTile(
                                        
                                        subtitle: const Text("Earned"),
                                        title: Text("₹ $expense"),
                                        titleTextStyle:  AppTheme.title,
                                        subtitleTextStyle: AppTheme.income,
                                        onTap: () {
                                          var displayEI=DisplayEI(
                                            income: true,
                                            expense: true
                                          );
                                          displayEI.expense=false;
                                          displayEI.income=true;
                                          Navigator.of(context).pushNamed(excalciSeeAllRoute,arguments: displayEI);
                                    
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
                                      color: const Color.fromARGB(169, 216, 77, 77),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: ListTile(
                                        subtitle: const Text("Earned"),
                                        title: const Text("₹ 0.0"),
                                        titleTextStyle:  AppTheme.title,
                                        subtitleTextStyle: AppTheme.expense,
                                        onTap: () {
                                          var displayEI=DisplayEI(
                                            income: true,
                                            expense: true
                                          );  
                                        displayEI.expense=false;
                                        displayEI.income=true;
                                        Navigator.of(context).pushNamed(excalciSeeAllRoute,arguments: displayEI);
                                  
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
        const SizedBox(height: 20,),
        Column(
          children: [
            const SizedBox(height: 20,),
            Row(
              children: [
                const SizedBox(width: 10,),
                Text('Your Recent Transactions:',style: AppTheme.title,),
                const SizedBox(width: 20,),
                TextButton(
                  child: const Text('See all'),
                  onPressed: (){
                    displayEI.expense=true;
                    displayEI.income=true;

                    Navigator.of(context).pushNamed(excalciSeeAllRoute,arguments: displayEI);
                  },
                )
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
                    itemCount: expenses.length>4?4:expenses.length,
                    itemBuilder: (context,index){
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
                                color: const Color.fromARGB(169, 67, 67, 67),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    //pop up expense view
                                    Navigator.of(context).pushNamed(excalciAddExpenseRoute,arguments: expense);
                                  
                                  },
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
                                color: const Color.fromARGB(169, 100, 152, 100),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTile(
                                  subtitle: Text(expense.desc.toString()),
                                  title: Text("₹"+expense.amount.toString()),
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
                    },
                  );
                }
                return const Center(child: Text('No expenses found!'));
              },
            ),
            const SizedBox(height: 20,),
            
          ],
        ),
        //Budget vs Expenses percentage bar with budget in yellow and fill percent of it in red for expenses
        const SizedBox(height: 20,),
        Row(
          children: [
            const SizedBox(width: 10,),
            Text('Budget Overview:',style: AppTheme.title,),
            const SizedBox(width: 0,),
            StreamBuilder<Iterable<CloudBudget>>(
              stream: _cloudService.currentMonthBudget(ownerUserId: ownerUserId),
              builder: (context,snapshot){
                if (snapshot.connectionState==ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError){
                  return const Center(child: Text('An error occurred!'));
                }
                if (snapshot.hasData){
                  final budget=snapshot.data!.first;
                  final value=budget.budget;


                  return  TextButton(
                    onPressed: (){
                      //pop up budget view
                      Navigator.of(context).pushNamed(excalciAddBudgetRoute,arguments: budget);
                    },
                    child: Text("Budget-₹$value",style: AppTheme.income,)
                  );
                }
                return  TextButton(
                  onPressed: (){
                    //pop up budget view
                    Navigator.of(context).pushNamed(excalciAddBudgetRoute);
                  },
                  child: Text("Budget-₹0.0",style: AppTheme.income,)
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 20,),


        


        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            child: StreamBuilder<double>(
              stream: _cloudService.percentageUsed(ownerUserId: ownerUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('An error occurred!'));
                }
                if (snapshot.hasData) {
                  percent = snapshot.data!;
                  return GFProgressBar(
                    percentage: percent/100,
                    lineHeight: 20,
                    alignment: MainAxisAlignment.spaceBetween,
                    
                    backgroundColor : const Color.fromARGB(169, 114, 114, 107),
                    progressBarColor: const Color.fromARGB(192, 207, 56, 56),
                    child: Text('${percent.floor()}%', textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 14, color: AppTheme.primary),
                                  )
                );

              }
              return GFProgressBar(
                    percentage: 0.0,
                    lineHeight: 20,
                    alignment: MainAxisAlignment.spaceBetween, 
                    backgroundColor : const Color.fromARGB(169, 114, 114, 107),
                    progressBarColor: const Color.fromARGB(192, 207, 56, 56),
                    child: Text('0%', textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 14, color: AppTheme.primary),
                                  )
                );
            },
            ),
          ),
        ),

        const SizedBox(height: 100,),

      ],
    );
  }
}
