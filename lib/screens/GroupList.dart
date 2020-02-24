import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_control/firebase/store.dart';

class GroupList extends StatelessWidget {
  GroupList({Key key}) : super(key: key);

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index < snapshot.length) {
            return _buildRow(context, snapshot.elementAt(index));
          }
          return null;
        });
  }

  Widget _buildRow(BuildContext context, DocumentSnapshot group) {
    return ListTile(
        leading: Icon(Icons.group),
        title: Text(group["title"]),
        trailing: Icon(Icons.delete));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Provider.of<Store>(context).groups.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            return snapshot.hasData
                ? _buildList(context, snapshot.data.documents)
                : Container();
        }
      },
    );
  }
}
