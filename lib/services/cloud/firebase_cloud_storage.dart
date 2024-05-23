
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excalci/services/cloud/cloud_accounts.dart';
import 'package:excalci/services/cloud/cloud_budget.dart';
import 'package:excalci/services/cloud/cloud_expense.dart';
import 'package:excalci/services/cloud/cloud_storage_constants.dart';
import 'package:excalci/services/cloud/cloud_storage_exceptions.dart';

import 'dart:developer' as dev;

class FirebaseCloudStorage {
  final expenses = FirebaseFirestore.instance.collection('Expenses');
  final categories = FirebaseFirestore.instance.collection('Categories');
  final accounts = FirebaseFirestore.instance.collection('Accounts');
  final budgets=FirebaseFirestore.instance.collection('Budget');

  


  //Create an expense

  Future<CloudExpense> createNewExpense({
    required String ownerUserId,
    }) async {
    final document = await expenses.add({
      ownerUserIdFieldName: ownerUserId,
      categoryFieldName: '',
      accountFieldName: '',
      amountFieldName: 0.0,
      timeFieldName: DateTime.now(),
      descFieldName: '',
      currencyFieldName: '₹',
      useCategoryFieldName: '',
    });
    final fetchedExpense = await document.get();
    return CloudExpense(
      documentId: fetchedExpense.id,
      ownerUserId: ownerUserId,
      category: '',
      account: '',
      amount: 0.0,
      date: DateTime.now(),
      desc: '',
      currency: '₹',
      useCategory: '',
    );
  }

  //Delete an expense

  Future<void> deleteExpense({required String documentId}) async {
    try {
      await expenses.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteExpenseException();
    }
  }

  //Update an expense

  Future<void> updateExpense({
    required String documentId,
    required String category,
    required String account,
    required double amount,
    required DateTime date,
    required String desc,
    required String currency,
    required String useCategory,
  }) async {
    try {
      await expenses.doc(documentId).update({
        categoryFieldName: category,
        accountFieldName: account,
        amountFieldName: amount,
        timeFieldName: date,
        descFieldName: desc,
        currencyFieldName: currency,
        useCategoryFieldName: useCategory,
      });
    } catch (e) {
      throw CouldNotUpdateExpenseException();
    }
  }

  //Get all expenses

  Stream<Iterable<CloudExpense>> allExpenses({required String ownerUserId}) {
    final allExpenses = expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Expense')
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudExpense.fromSnapshot(doc)));
    return allExpenses;
  }

  //Get all incomes

  Stream<Iterable<CloudExpense>> allIncomes({required String ownerUserId}) {
    final allIncomes = expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Income')
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudExpense.fromSnapshot(doc)));
    return allIncomes;
  }
  
  //Get all expenses for a category

  Stream<Iterable<CloudExpense>> allExpensesForCategory({
    required String ownerUserId,
    required String category,
  }) {
    final allExpensesForCategory = expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Expense')
        .where(useCategoryFieldName, isEqualTo: category)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudExpense.fromSnapshot(doc)));
    return allExpensesForCategory;
  }
  //count of expenses

  int countOfExpenses({required String ownerUserId}) {
    int countOfExpenses = 0;
    expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .get()
        .then((value) => countOfExpenses = value.docs.length);
    
    return countOfExpenses;
  }

  
  

  //get last 4 expenses 

  Stream<Iterable<CloudExpense>> sortedExpenses({required String ownerUserId}) {
    // return last 4 transactions, if the count is less than 4 return all of them
    int count=countOfExpenses(ownerUserId: ownerUserId);
    if(count>4){
      final last4Expenses = expenses
              .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
              .orderBy(timeFieldName, descending: true)
              .limit(4)
              .snapshots()
              .map((event) => event.docs.map((doc) => CloudExpense.fromSnapshot(doc)));
      return last4Expenses;
    }
    else{
      final allExpenses = expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudExpense.fromSnapshot(doc)));
    return allExpenses;
    }
  }

  //amount spent over a month

  Stream<double> amountSpentOverMonth({required String ownerUserId}) {
    final amountSpentOverMonth = expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Expense')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudExpense.fromSnapshot(doc))
            .where((element) =>
                element.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))
            .map((e) => e.amount.toDouble())
            .reduce((value, element) => value + element));
    return amountSpentOverMonth;
  }
  Stream<double> amountIncomeOverMonth({required String ownerUserId}) {
    final amountSpentOverMonth = expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Income')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudExpense.fromSnapshot(doc))
            .where((element) =>
                element.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))
            .map((e) => e.amount.toDouble())
            .reduce((value, element) => value + element));
    return amountSpentOverMonth;
  }

// ========================================================================================================================

  //create accounts default for every user

  Future<CloudAccounts> createAccounts({required String ownerUserId}) async {
    final document = await accounts.add({
      ownerUserIdFieldName: ownerUserId,
      'Bank': {
        'Used amount': 0,
        'balance': 0,
        'txns': 0,
      },
      'Cash': {
        'Used percent': 0,
        'txns': 0,
        'used_amt': 0,
      },
    });
    final fetchedAccounts = await document.get();
    return CloudAccounts(
      documentId: fetchedAccounts.id,
      ownerUserId: ownerUserId,
      Bank: BankDefault,
      Cash: CashDefault,
    );
  }


  //Update in accounts

  Future<void> updateAccounts({
    required String documentId,
    required Map<String,dynamic> accountBank,
    required Map<String,dynamic> accountCash,

  }) async {
    try {
      await accounts.doc(documentId).update({
        'Bank': accountBank,
        'Cash': accountCash,
      });
    } catch (e) {
      throw CouldNotUpdateAccountsException();
    }
  }

  //Get all accounts

  Stream<Iterable<CloudAccounts>> allAccounts({required String ownerUserId}) {
    final allAccounts = accounts
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudAccounts.fromSnapshot(doc)));
    return allAccounts;
  }



  //========================================================================================================================

  //Create a budget

  Future<CloudBudget> createBudget({
    required String ownerUserId,
    required double budget,
    required double month,
  }) async {
    final document = await budgets.add({
      ownerUserIdFieldName: ownerUserId,
      budgetFieldName: budget,
      budgetMonthFieldName: month,
    });
    final fetchedBudget = await document.get();
    return CloudBudget(
      documentId: fetchedBudget.id,
      ownerUserId: ownerUserId,
      budget: budget,
      month: month,
    );
  }

  //Delete a budget

  Future<void> deleteBudget({required String documentId}) async {
    try {
      await budgets.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteBudgetException();
    }
  }

  //Update a budget

  Future<void> updateBudget({
    required String documentId,
    required double budget,
    required double month,
  }) async {
    try {
      await budgets.doc(documentId).update({
        budgetFieldName: budget,
        budgetMonthFieldName: month,
      });
    } catch (e) {
      throw CouldNotUpdateBudgetException();
    }
  }

  //get current month budget

  double currentYYYYMM(){
    DateTime now=DateTime.now();
    return double.parse('${now.year}${now.month}');
  }

  Stream<double> currentMonthBudget({required String ownerUserId}) {
    var currentMonthBudget =budgets
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(budgetMonthFieldName, isEqualTo: currentYYYYMM().toInt())
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudBudget.fromSnapshot(doc))
            .map((e) => e.budget)
            .reduce((value, element) => value + element));   
    return currentMonthBudget;
  }

  //percentage of budget used in a month

  Stream<double> percentageUsed({required String ownerUserId})async*{
    var ex = await expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Expense')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudExpense.fromSnapshot(doc))
            .where((element) =>
                element.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))
            .map((e) => e.amount.toDouble())
            .reduce((value, element) => value + element)).first;
    var bu =await budgets
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(budgetMonthFieldName, isEqualTo: currentYYYYMM().toInt())
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudBudget.fromSnapshot(doc))
            .map((e) => e.budget)
            .reduce((value, element) => value + element)).first;
    double percentageUsed = (ex/bu)*100;
    yield percentageUsed;
  }





  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}


