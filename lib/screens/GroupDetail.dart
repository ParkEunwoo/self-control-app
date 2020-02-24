import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:self_control/data/participant.dart';
import 'package:self_control/firebase/admob.dart';
import 'package:self_control/firebase/store.dart';

import 'Calendar.dart';
import 'RemainingTime.dart';


class GroupDetail extends StatelessWidget {
  String id;
  String title;

  GroupDetail({this.id, this.title});

  @override
  Widget build(BuildContext context) {
    AdMob.instance.showBanner();
    return ChangeNotifierProvider<Participant>(
      create: (context) => Participant(id:Provider.of<Store>(context).user.documentID),
      child: Scaffold(
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
              //Content(context),
            ],
          )),
    );
  }
/*
  Widget Content(BuildContext context) {
    StreamBuilder<DocumentSnapshot>(
      stream:
      Provider.of<Store>(context).getGroup(id).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            return snapshot.hasData
                ? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:16.0, top: 16, bottom:16),
                  child: Text(snapshot.data['title'], style:TextStyle(fontSize:22)),
                ),
                Divider()
                //Content(context, snapshot.data),
              ],
            )
                : Container();
        }
      },
    )
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
  }*/
}
