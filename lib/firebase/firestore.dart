import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetCollectionsCustomers {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCollections(String service, String client, String collection) {
    final services = _firestore
        .collection(collection)
        .where('servicio', isEqualTo: service)
        .where('cliente', isEqualTo: client)
        .snapshots();
    return services;
  }
}

class GetCollectionsLoan {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCollections(String collection, String typecollection) {
    final services = _firestore.collection('$typecollection+$collection').snapshots();
    return services;
  }
}
