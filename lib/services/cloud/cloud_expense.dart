import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excalci/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudExpense {
  final String documentId;
  final String ownerUserId;
  final String category;
  final String useCategory;
  final Map<String,bool> account;
  final double amount;
  final DateTime date;
  final String desc;
  final String currency;

  CloudExpense( {
    required this.documentId,
    required this.ownerUserId,
    required this.category,
    required this.account,
    required this.amount,
    required this.date,
    required this.desc,
    required this.currency,
    required this.useCategory,
  });

  CloudExpense.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,)   : 
        documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        category = snapshot.data()[categoryFieldName],
        account = (snapshot.data()[accountFieldName] as Map<String,bool>),
        amount = snapshot.data()[amountFieldName],
        date = (snapshot.data()[timeFieldName] as Timestamp).toDate(),
        desc = snapshot.data()[descFieldName],
        currency = snapshot.data()[currencyFieldName],
        useCategory = snapshot.data()[useCategoryFieldName];




  // CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
  //     : documentId = snapshot.id,
  //       ownerUserId = snapshot.data()[ownerUserIdFieldName],
  //       text = snapshot.data()[textFieldName] as String;
}
