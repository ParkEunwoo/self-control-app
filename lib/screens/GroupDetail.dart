import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:self_control/data/participant.dart';
import 'package:self_control/firebase/admob.dart';
import 'package:self_control/firebase/store.dart';
import 'package:self_control/screens/DetailPage.dart';

import 'Calendar.dart';
import 'RemainingTime.dart';

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

class ParticipantPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(Provider.of<Participant>(context).plan == '') {
      if(Provider.of<Participant>(context).id == Provider.of<Store>(context).user.documentID) {
        return Center(child:IconButton(icon:Icon(Icons.add_circle), iconSize: 64,));
      }
      return Center(child:Icon(Icons.error, size: 64));
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
          authentication: true,
        )
      ],
    );
  }
}

class ParticipantsList extends StatelessWidget {
  String id;

  ParticipantsList({this.id});

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8.0),
        itemCount: snapshot.length,
        itemBuilder: (context, i) {
          return _buildColumn(
              context,
              snapshot.elementAt(i),
              Provider.of<Participant>(context)
                  .isSelected(snapshot.elementAt(i).documentID));
        });
  }

  Widget _buildColumn(
      BuildContext context, DocumentSnapshot participant, bool isSelected) {
    return Container(
      padding: const EdgeInsets.only(top: 4.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.lightBlue : Colors.white,
          border: Border.all(color: Colors.blue)),
      width: 80,
      child: ListTile(
          onTap: () {
            Provider.of<Participant>(context, listen: false)
                .setParticipant(participant.documentID, participant['plan']);
          },
          title: Icon(Icons.perm_identity,
              color: isSelected ? Colors.white : Colors.lightBlue),
          subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(participant['name'],
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 12)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Provider.of<Store>(context)
          .getGroup(id)
          .collection('participants')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return LinearProgressIndicator();
          default:
            return snapshot.hasData
                ? _buildList(context, snapshot.data.documents)
                : Container();
        }
      },
    );
  }
}
