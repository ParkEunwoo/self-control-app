import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Store with ChangeNotifier {
  static final Firestore db = Firestore.instance;
  static final CollectionReference Users =
      db.collection('users');
  DocumentReference user;
  CollectionReference plans;

  Store(String uid) {
    user = Users.document(uid);
    plans = user.collection('plans');
  }

  static void createUser(
      {@required String uid,
      @required String email,
      @required String name}) async {
    await Users.document(uid).setData({"email": email, "name": name});
  }

  void login(String uid) {
    user = Users.document(uid);
    plans = user.collection('plans');
  }


  static void printLog(List<DocumentSnapshot> documents){
    documents.forEach((document){
      print('document ${document['title']}');
    });
  }
}
