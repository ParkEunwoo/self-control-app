import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Participant with ChangeNotifier {
  String id = "";
  DocumentReference plan = null;
  Participant();
  void initPlan(DocumentReference plan) {
    this.plan = plan;
  }
  void setParticipant(String id) {
    this.id = id;
    notifyListeners();
  }
  bool isSelected(String id) {
    if(this.id == id){
      return true;
    }
    return false;
  }
}