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

  void addPlan(Plan plan) async {
    await plans.add({
      "title": plan.title,
      "period": plan.period,
      "times": plan.times,
      "timesUnit": plan.timesUnit,
      "now": 0,
      "isPositive": plan.isPositive
    });
    notifyListeners();
  }

  void addFriend(String email) {
    Users.where("email", isEqualTo: email)
        .snapshots()
        .listen((onData) => onData.documents.forEach((doc) {
              friends.add({"email": email, "name": doc['name']});
            }));
    notifyListeners();
  }

  void removeFriend(String id) {
    friends.document(id).delete();
    notifyListeners();
  }

  static void createUser(
      {@required String uid,
      @required String email,
      @required String name}) async {
    await Users.document(uid).setData({"email": email, "name": name});
  }
}
