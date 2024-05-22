import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/services/cloud/cloud_expense.dart';
import 'package:excalci/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;
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

  @override
  void initState() {
    _cloudService=FirebaseCloudStorage();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // return all expenses in LIGHT RED, incomes in green
    return  Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 20,),
            const Text('Your Expenses',style: TextStyle(fontSize: 20),),
            const SizedBox(height: 20,),
            StreamBuilder<Iterable<CloudExpense>>(
              stream: _cloudService.allExpenses(ownerUserId: ownerUserId),
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
                      final expense=expenses.elementAt(index);
                      return ListTile(
                        title: Text(expense.desc),
                        subtitle: Text(expense.amount.toString()),
                      );
                    },
                  );
                }
                return const Center(child: Text('No expenses found!'));
              },
            ),
            const SizedBox(height: 20,),
            const Text('Your Incomes',style: TextStyle(fontSize: 20),),
            const SizedBox(height: 20,),
            StreamBuilder<Iterable<CloudExpense>>(
              stream: _cloudService.allIncomes(ownerUserId: ownerUserId),
              builder: (context,snapshot){
                if (snapshot.connectionState==ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError){
                  return const Center(child: Text('An error occurred!'));
                }
                if (snapshot.hasData){
                  final incomes=snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: incomes.length,
                    itemBuilder: (context,index){
                      final income=incomes.elementAt(index);
                      return ListTile(
                        title: Text(income.desc),
                        subtitle: Text(income.amount.toString()),
                      );
                    },
                  );
                }
                return const Center(child: Text('No incomes found!'));
              },
            ),
          ],
        ),
      ],
    );
  }
}
