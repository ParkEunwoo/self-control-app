import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_control/data/participant.dart';
import 'package:self_control/firebase/store.dart';

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
            return Center(child: CircularProgressIndicator());
          default:
            return snapshot.hasData
                ? _buildList(context, snapshot.data.documents)
                : Container();
        }
      },
    );
  }
}
