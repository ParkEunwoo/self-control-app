import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:self_control/firebase/admob.dart';
import 'package:self_control/firebase/store.dart';

import 'Calendar.dart';
import 'RemainingTime.dart';

class DetailPage extends StatelessWidget {
  String id;

  DetailPage({this.id});

  @override
  Widget build(BuildContext context) {
    AdMob.instance.showBanner();
    return Scaffold(
        appBar: AppBar(
          title: Text("DetailPage"),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream:
              Provider.of<Store>(context).plans.document(id).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                return snapshot.hasData
                    ? Content(context, snapshot.data)
                    : Container();
            }
          },
        ));
  }

  Widget Content(BuildContext context, DocumentSnapshot data) {
    return Column(
      children: <Widget>[
        Text(data['title'], style: TextStyle(fontSize: 20)),
        RemainingTime(
            period: data['period'], goal: DateTime.parse(data['goalDate'])),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('1${data['period']}'),
              Text("${data['now']}/${data['times']}${data['timesUnit']}"),
            ]),
        Calendar(
          startDate: data['startDate'],
          period: data['period'],
          times: data['times'],
          now: data['now'],
          isPositive: data['isPositive'],
          plan: Provider.of<Store>(context).plans.document(id),
          authentication: true,
        )
      ],
    );
  }
}
