import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetCollectionsCustomers {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCollections(String service, String client) {
    final services = _firestore
        .collection('Clientes')
        .where('servicio', isEqualTo: service)
        .where('cliente', isEqualTo: client)
        .snapshots();
    return services;
  }
}

class GetCollectionsLoan {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCollections(String collection) {
    final services = _firestore
        .collection('Clientes+$collection')
        .snapshots();
    return services;
  }
}

