import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excalci/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudBudget {
  final String documentId;
  final String ownerUserId;
  final double budget;
  final double month;

  
  CloudBudget( {
    required this.documentId,
    required this.ownerUserId,
    required this.budget,
    required this.month,
  });

  CloudBudget.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,)   : 
        documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        budget = snapshot.data()[budgetFieldName],
        month = snapshot.data()[budgetMonthFieldName];

  
}
