import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excalci/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudAccounts {
  final String documentId;
  final String ownerUserId;
  final Map<String,dynamic> Bank;
  final Map<String,dynamic> Cash;
  
  CloudAccounts( {
    required this.documentId,
    required this.ownerUserId,
    required this.Bank,
    required this.Cash,
  });

  CloudAccounts.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,)   : 
        documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        Bank = (snapshot.data()[accountFieldName_Bank] as Map<String,dynamic>),
        Cash = (snapshot.data()[accountFieldName_Cash] as Map<String,dynamic>);
  
}
