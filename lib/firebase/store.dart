import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:self_control/data/plan.dart';

class Store with ChangeNotifier {
  static final Firestore db = Firestore.instance;
  static final CollectionReference Users = db.collection('users');
  DocumentReference user;
  CollectionReference plans;
  CollectionReference friends;
  String _email;
  String _name;

  void setUid(String uid) {
    user = Users.document(uid);
    plans = user.collection('plans');
    friends = user.collection('friends');
    user.get().then((DocumentSnapshot ds) {
      _email = ds['email'];
      _name = ds['name'];
    });

  }

  static DateTime getGoalTime(String period) {
    DateTime now = DateTime.now();
    switch (period) {
      case '주':
        return DateTime(now.year, now.month,
            now.day + (now.weekday > 0 ? 7 - now.weekday : 0), 23, 59, 59);
      case '일':
      default:
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
    }
  }
  void addPlan(Plan plan) async {
    await plans.add({
      "title": plan.title,
      "period": plan.period,
      "times": plan.times,
      "timesUnit": plan.timesUnit,
      "now": 0,
      "isPositive": plan.isPositive,
      "startDate": '${DateTime.now().toString().substring(0, 10)} 12',
      "goalDate": '${getGoalTime(plan.period)}'
    });
    notifyListeners();
  }


  void addFriend(String email) {
    Users.where("email", isEqualTo: email)
        .snapshots()
        .listen((onData) => onData.documents
        .forEach((doc) {
              friends.document(doc.documentID).setData({"email": email, "name": doc['name'], "status": "request"});
              Users.document(doc.documentID).collection('friends').document(user.documentID).setData({"email":_email,"name":_name, "status": "respond"});
            }));
    notifyListeners();
  }

  void acceptFriend(String id) {
    friends.document(id).updateData({"status": "accepted"});
    Users.document(id).collection('friends').document(user.documentID).updateData({"status":"accepted"});
  }


  void removeFriend(String id) {
    friends.document(id).delete();
    notifyListeners();
  }

  void addGroup() {

  }

  static void createUser(
      {@required String uid,
      @required String email,
      @required String name}) async {
    await Users.document(uid).setData({"email": email, "name": name});
  }
}
