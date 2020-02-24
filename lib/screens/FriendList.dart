import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_control/firebase/store.dart';

class FriendList extends StatelessWidget {
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

  Widget _buildRow(BuildContext context, DocumentSnapshot friend) {
    return ListTile(
        leading: Icon(Icons.person),
        title: Text(friend['name']),
        subtitle: Text(friend['email']),
        trailing: friendStatus(
            friend['status'],
            friend.documentID,
            Provider.of<Store>(context).removeFriend,
            Provider.of<Store>(context).acceptFriend));
  }

  Widget friendStatus(
      String status, String id, Function removeFriend, Function acceptFriend) {
    switch (status) {
      case 'request':
        return FlatButton(
            onPressed: null,
            child: Text('요청 보냄', style: TextStyle(fontSize: 12)));
      case 'respond':
        return FlatButton(
            child: Text('수락 하기', style: TextStyle(fontSize: 12)),
            textTheme: ButtonTextTheme.primary,
            color: Colors.primaries[5],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              acceptFriend(id);
            });
      case 'accepted':
      default:
        return IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              removeFriend(id);
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Provider.of<Store>(context).friends.snapshots(),
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
        });
  }
}
