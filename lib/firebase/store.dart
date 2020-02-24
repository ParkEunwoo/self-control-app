import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:self_control/data/group.dart';
import 'package:self_control/data/plan.dart';

class Store with ChangeNotifier {
  static final Firestore db = Firestore.instance;
  static final CollectionReference USERS = db.collection('users');
  static final CollectionReference GROUPS = db.collection('groups');
  DocumentReference user;
  CollectionReference plans;
  CollectionReference friends;
  CollectionReference groups;
  String _email;
  String _name;

  DocumentReference getGroup(String id) => GROUPS.document(id);
  DocumentReference getGroupPlan(String uid, String plan) => USERS.document(uid).collection('plans').document(plan);

  void setUid(String uid) {
    user = USERS.document(uid);
    plans = user.collection('plans');
    friends = user.collection('friends');
    groups = user.collection('groups');
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
    USERS
        .where("email", isEqualTo: email)
        .snapshots()
        .listen((onData) => onData.documents.forEach((doc) {
              friends.document(doc.documentID).setData(
                  {"email": email, "name": doc['name'], "status": "request"});
              USERS
                  .document(doc.documentID)
                  .collection('friends')
                  .document(user.documentID)
                  .setData(
                      {"email": _email, "name": _name, "status": "respond"});
            }));
    notifyListeners();
  }

  void acceptFriend(String id) {
    friends.document(id).updateData({"status": "accepted"});
    USERS
        .document(id)
        .collection('friends')
        .document(user.documentID)
        .updateData({"status": "accepted"});
  }

  void removeFriend(String id) {
    friends.document(id).delete();
    notifyListeners();
  }

  void addGroup(Group group) async {
    DocumentReference result = await GROUPS.add({"title": group.title});
    result
        .collection('participants')
        .document(user.documentID)
        .setData({"plan": '', "name": _name});
    user
        .collection("groups")
        .document(result.documentID)
        .setData({"title": group.title});

    group.friends.forEach((id, name) {
      result.collection('participants').document(id).setData({"plan": '', "name": name});
      USERS
          .document(id)
          .collection('groups')
          .document(result.documentID)
          .setData({"title": group.title});
    });
    notifyListeners();
  }

  void removeGroup(String id) async {
    groups.document(id).delete();
    QuerySnapshot participants = await GROUPS.document(id).collection("participants").getDocuments();
    participants.documents.forEach((participants){
      USERS.document(participants.documentID).collection("groups").document(id).delete();
    });
    GROUPS.document(id).delete();
    notifyListeners();
  }

  static void createUser(
      {@required String uid,
      @required String email,
      @required String name}) async {
    await USERS.document(uid).setData({"email": email, "name": name});
  }
}
