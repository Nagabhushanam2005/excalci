import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excalci/services/cloud/cloud_accounts.dart';
import 'package:excalci/services/cloud/cloud_categories.dart';
import 'package:excalci/services/cloud/cloud_expense.dart';
import 'package:excalci/services/cloud/cloud_storage_constants.dart';
import 'package:excalci/services/cloud/cloud_storage_exceptions.dart';
// import 'package:flutter/foundation.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  final expenses = FirebaseFirestore.instance.collection('Expenses');
  final categories = FirebaseFirestore.instance.collection('Categories');
  final accounts = FirebaseFirestore.instance.collection('Accounts');
  


  //Create an expense

  Future<CloudExpense> createNewExpense({
    required String ownerUserId,
    }) async {
    final document = await expenses.add({
      ownerUserIdFieldName: ownerUserId,
      categoryFieldName: '',
      accountFieldName: {},
      amountFieldName: 0.0,
      timeFieldName: DateTime.now(),
      descFieldName: '',
      currencyFieldName: '',
      useCategoryFieldName: '',
    });
    final fetchedExpense = await document.get();
    return CloudExpense(
      documentId: fetchedExpense.id,
      ownerUserId: ownerUserId,
      category: '',
      account: {},
      amount: 0.0,
      date: DateTime.now(),
      desc: '',
      currency: '',
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
    required Map<String,bool> account,
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
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudExpense.fromSnapshot(doc)));
    return allExpenses;
  }


  //Get all categories

  Stream<Iterable<CloudCategories>> allCategories({required String ownerUserId}) {
    final allCategories = categories
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudCategories.fromSnapshot(doc)));
    return allCategories;
  }

  //Create a new category

  Future<CloudCategories> createNewCategory({required String ownerUserId}) async {
    final document = await categories.add({
      ownerUserIdFieldName: ownerUserId,
      categoryExpenseFieldName: {},
      categoryIncomeFieldName:  {},
    });
    final fetchedCategory = await document.get();
    return CloudCategories(
      documentId: fetchedCategory.id,
      ownerUserId: ownerUserId,
      categoryExpense: categoryExpenseDefault,
      categoryIncome: categoryIncomeDefault,
    );
  }

  //Update a category

  Future<void> updateCategory({
    required String documentId,
    required Map<String,String> categoryExpense,
    required Map<String,String> categoryIncome,
  }) async {
    try {
      await categories.doc(documentId).update({
        categoryExpenseFieldName: categoryExpense,
        categoryIncomeFieldName: categoryIncome,
      });
    } catch (e) {
      throw CouldNotUpdateCategoryException();
    }
  }

  //Delete a category

  Future<void> deleteCategory({required String documentId}) async {
    try {
      await categories.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteCategoryException();
    }
  }

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




  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}


