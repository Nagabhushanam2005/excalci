
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

  Stream<int> countExpenses({required String ownerUserId}) {
    final countExpenses = expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Expense')
        .snapshots()
        .map((event) => event.docs.length);
    return countExpenses;
  }
  
  
  

  //get last 4 expenses 

  Stream<Iterable<CloudExpense>> sortedExpenses({required String ownerUserId}) {
    final sortedExpenses = expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudExpense.fromSnapshot(doc)));
    return sortedExpenses;
    
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
        'balance': 0,
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

  //delete account

  Future<void> deleteAccount({required String documentId}) async {
    try {
      await accounts.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteAccountsException();
    }
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

  Stream<Iterable<CloudBudget>> currentMonthBudget({required String ownerUserId}) {
    var currentMonthBudget =budgets
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(budgetMonthFieldName, isEqualTo: currentYYYYMM().toInt())
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudBudget.fromSnapshot(doc)));   
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





  //========================================================================================================================

  // all expenses in different categories with percentage of budget

  Stream<Map<String,double>> allExpensesInCategories({required String ownerUserId}) async*{
    var bu =await budgets
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(budgetMonthFieldName, isEqualTo: currentYYYYMM().toInt())
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudBudget.fromSnapshot(doc))
            .map((e) => e.budget)
            .reduce((value, element) => value + element)).first;
    var allExpensesInCategories =await expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Expense')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudExpense.fromSnapshot(doc))
            .where((element) =>
                element.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))).first;
            // .map((e) => e.amount.toDouble())
            // .reduce((value, element) => value + element));
    var allExpensesInCategoriesMap = Map<String,double>();
    for (var e in allExpensesInCategories) {
      if(allExpensesInCategoriesMap.containsKey(e.useCategory)){
        allExpensesInCategoriesMap[e.useCategory]=(allExpensesInCategoriesMap[e.useCategory]!*bu/100+e.amount)/bu*100;
      }
      else{
        allExpensesInCategoriesMap[e.useCategory]=e.amount/bu*100;
      }
    }
    dev.log(allExpensesInCategoriesMap.toString());
    
    // allExpensesInCategoriesMap['Total']=ex;
    // allExpensesInCategoriesMap['Budget']=bu;
    yield allExpensesInCategoriesMap;
  }

  // all incomes in different categories with percentage of whole income 

  Stream<Map<String,double>> allIncomesInCategories({required String ownerUserId}) async*{
    var allIncomesInCategories = await expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Income')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudExpense.fromSnapshot(doc))
            .where((element) =>
                element.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))).first;
    var allIncomesInCategoriesMap = Map<String,double>();
    var income=await amountIncomeOverMonth(ownerUserId: ownerUserId).first;
    for (var e in allIncomesInCategories) {
      if(allIncomesInCategoriesMap.containsKey(e.useCategory)){
        allIncomesInCategoriesMap[e.useCategory]=((allIncomesInCategoriesMap[e.useCategory]!*100/income)+e.amount)/income*100;
      }
      else{
        allIncomesInCategoriesMap[e.useCategory]=e.amount/income*100;
      }
    }
    // allIncomesInCategoriesMap['Total']=income;
    yield allIncomesInCategoriesMap;
  }


  // cash, bank based expenses

  Stream<Map<String,double>> cashBankExpenses({required String ownerUserId}) async*{
    var allExpensesInCategories =await expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Expense')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudExpense.fromSnapshot(doc))
            .where((element) =>
                element.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))).first;
    var allExpensesInCategoriesMap = Map<String,double>();

    for (var e in allExpensesInCategories) {
      if(allExpensesInCategoriesMap.containsKey(e.account)){
        allExpensesInCategoriesMap[e.account]=allExpensesInCategoriesMap[e.account]!+e.amount;
      }
      else{
        allExpensesInCategoriesMap[e.account]=e.amount;
      }
    }
    var tot=await amountSpentOverMonth(ownerUserId: ownerUserId).first;
    allExpensesInCategoriesMap['Total']=tot;
    dev.log(allExpensesInCategoriesMap.toString());
    yield allExpensesInCategoriesMap;
  } 

  // cash, bank based incomes

  Stream<Map<String,double>> cashBankIncomes({required String ownerUserId}) async*{
    var allExpensesInCategories =await expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Income')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudExpense.fromSnapshot(doc))
            .where((element) =>
                element.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))).first;
    var allExpensesInCategoriesMap = Map<String,double>();

    for (var e in allExpensesInCategories) {
      if(allExpensesInCategoriesMap.containsKey(e.account)){
        allExpensesInCategoriesMap[e.account]=allExpensesInCategoriesMap[e.account]!+e.amount;
      }
      else{
        allExpensesInCategoriesMap[e.account]=e.amount;
      }
    }
    var tot=await amountIncomeOverMonth(ownerUserId: ownerUserId).first;
    allExpensesInCategoriesMap['Total']=tot;
    dev.log(allExpensesInCategoriesMap.toString());
    yield allExpensesInCategoriesMap;
  } 


  //merge cash banks

  Stream<Iterable<Map<String,double>>> cashBank({required String ownerUserId})async*{
    var cashBankExpense = await cashBankExpenses(ownerUserId: ownerUserId).first;
    var cashBankIncome =await  cashBankIncomes(ownerUserId: ownerUserId).first;
    var cashBankMap = [cashBankExpense,cashBankIncome];
    yield cashBankMap;
  }


  // average value of each transaction

  Stream<double> averageValue({required String ownerUserId}) async*{
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
    var tx = await expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Expense')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudExpense.fromSnapshot(doc))
            .where((element) =>
                element.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))
            .map((e) => 1)
            .reduce((value, element) => value + element)).first;
    double averageValue = ex/tx;
    yield averageValue;
  }

  // number of transactions over 1000 amount

  Stream<int> transactionsOver1000({required String ownerUserId}) async*{
    var tx = await expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Expense')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudExpense.fromSnapshot(doc))
            .where((element) =>
                element.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))
            .map((e) => e.amount.toDouble())
            .where((element) => element>1000)
            .map((e) => 1)
            .reduce((value, element) => value + element)).first;
    yield tx;
  }

  // number of transactions in bank

  Stream<int> transactionsInBank({required String ownerUserId}) async*{
    var tx = await expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Expense')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudExpense.fromSnapshot(doc))
            .where((element) =>
                element.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))
            .where((element) => element.account=='Bank')
            .map((e) => 1)
            .reduce((value, element) => value + element)).first;
    yield tx;
  }

  // number of transactions in cash

  Stream<int> transactionsInCash({required String ownerUserId}) async*{
    var tx = await expenses
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(categoryFieldName, isEqualTo: 'Expense')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudExpense.fromSnapshot(doc))
            .where((element) =>
                element.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))
            .where((element) => element.account=='Cash')
            .map((e) => 1)
            .reduce((value, element) => value + element)).first;
    yield tx;
  }





  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}


