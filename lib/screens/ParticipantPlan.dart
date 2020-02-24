import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_control/data/participant.dart';
import 'package:self_control/firebase/store.dart';
import 'package:self_control/screens/Calendar.dart';
import 'package:self_control/screens/RemainingTime.dart';

class ParticipantPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<Participant>(context).plan == '') {
      if (Provider.of<Participant>(context).id ==
          Provider.of<Store>(context).user.documentID) {
        return Center(
            child: IconButton(
                icon: Icon(Icons.add_circle),
                iconSize: 64,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                          title: Text('나의 계획 선택하기'),
                          children: Provider.of<Store>(context, listen: false)
                              .getPlanList()
                              .entries
                              .map((entry) => SimpleDialogOption(
                                  child: Text(entry.value),
                                  onPressed: () {
                                    Navigator.of(context).pop();

                                    Provider.of<Participant>(context,
                                            listen: false)
                                        .group
                                        .collection('participants')
                                        .document(Provider.of<Store>(context,
                                                listen: false)
                                            .user
                                            .documentID)
                                        .updateData({"plan": entry.key});
                                    Provider.of<Participant>(context,
                                            listen: false)
                                        .setParticipant(
                                            Provider.of<Store>(context,
                                                    listen: false)
                                                .user
                                                .documentID,
                                            entry.key);
                                  }))
                              .toList()));
                }));
      }
      return Center(child: Icon(Icons.error, size: 64));
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: Provider.of<Store>(context)
          .getGroupPlan(Provider.of<Participant>(context).id,
              Provider.of<Participant>(context).plan)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return snapshot.hasData
                ? Content(context, snapshot.data)
                : Container();
        }
      },
    );
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
          plan: Provider.of<Store>(context).getGroupPlan(
              Provider.of<Participant>(context).id,
              Provider.of<Participant>(context).plan),
          authentication: false,
        )
      ],
    );
  }
}
