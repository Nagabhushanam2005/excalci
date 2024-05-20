import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excalci/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudCategories {

  final String documentId;
  final String ownerUserId;
  final Map<String,String> categoryExpense;
  final Map<String,String> categoryIncome;

  CloudCategories( {
    required this.documentId,
    required this.ownerUserId,
    required this.categoryExpense,
    required this.categoryIncome,
  });

  CloudCategories.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,)   : 
        documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        categoryExpense = (snapshot.data()[categoryExpenseFieldName] as Map<String,String>),
        categoryIncome = (snapshot.data()[categoryIncomeFieldName] as Map<String,String>);

  
  
}
