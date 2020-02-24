import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:self_control/firebase/store.dart';

class Participant with ChangeNotifier {
  String id = '';
  String plan = "";
  String groupId = "";
  DocumentReference group;

  void setGroup(String id, String uid) {
    this.groupId = id;
    group = Store.GROUPS.document(id);
    setParticipant(uid, '');
    notifyListeners();
  }

  void setParticipant(String id, String plan) {
    this.id = id;
    this.plan = plan;
    notifyListeners();
  }

  bool isSelected(String id) {
    if (this.id == id) {
      return true;
    }
    return false;
  }
}
