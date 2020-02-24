import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Participant with ChangeNotifier {
  String id;
  DocumentReference plan;
  Participant({this.id});
  void setPlan(DocumentReference plan) {
    this.plan = plan;
  }
}