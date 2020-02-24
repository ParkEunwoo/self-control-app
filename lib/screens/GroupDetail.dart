import "package:flutter/material.dart";
import 'package:self_control/firebase/admob.dart';
import 'package:self_control/screens/ParticipantPlan.dart';
import 'package:self_control/screens/ParticipantsList.dart';

class GroupDetail extends StatelessWidget {
  String id;
  String title;

  GroupDetail({this.id, this.title});

  @override
  Widget build(BuildContext context) {
    AdMob.instance.showBanner();
    return Scaffold(
        appBar: AppBar(
          title: Text("DetailPage"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(title, style: TextStyle(fontSize: 22)),
            ),
            Divider(),
            Container(height: 80, child: ParticipantsList(id: id)),
            Expanded(child: ParticipantPlan())
          ],
        ));
  }
}
