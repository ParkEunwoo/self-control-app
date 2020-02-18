import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:self_control/data/plan.dart';

class Store with ChangeNotifier {
  static final Firestore db = Firestore.instance;
  static final CollectionReference Users = db.collection('users');
  DocumentReference user;
  CollectionReference plans;
  CollectionReference friends;

  Store(String uid) {
    user = Users.document(uid);
    plans = user.collection('plans');
    friends = user.collection('friends');
  }

  void addPlan(
      {@required String title,
      @required int period,
      @required String periodUnit,
      @required int times,
      @required String timesUnit,
      @required bool isPositive}) async {
    await plans.add({
      "title": title,
      "period": period,
      "periodUnit": periodUnit,
      "times": times,
      "timesUnit": timesUnit,
      "now": 0,
      "isPositive": isPositive
    });
    notifyListeners();
  }



  static void createUser(
      {@required String uid,
      @required String email,
      @required String name}) async {
    await Users.document(uid).setData({"email": email, "name": name});
  }
}
