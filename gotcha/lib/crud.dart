import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(carData) async {
    if (isLoggedIn()) {
      Firestore.instance.collection('pi_config_states').add(carData).catchError((e) {
        print(e);
      });
      //Using Transactions
      // Firestore.instance.runTransaction((Transaction crudTransaction) async {
      //   CollectionReference reference =
      //       await Firestore.instance.collection('testcrud');

      //   reference.add(carData);
      // });
    } else {
      print('You need to be logged in');
    }
  }

  getData() async {
    return await Firestore.instance.collection('pi_config_states').snapshots();
  }

  updateData(collection, selectedDoc, newValues) {
    Firestore.instance
        .collection(collection)
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId) {
    Firestore.instance
        .collection('pi_config_states')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}