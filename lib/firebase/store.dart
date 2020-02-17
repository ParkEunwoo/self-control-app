import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Store {
  static final DocumentReference User = Firestore.instance.collection('users').document();
  static void createUser({@required String uid, @required String name}) async {
    await User.setData({uid:uid, name:name});
  }
}