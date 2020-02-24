import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_control/firebase/store.dart';

class FriendList extends StatefulWidget {
  bool checkable;

  FriendList({Key key, this.checkable}) : super(key: key);

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  Map<String, bool> checkList = {};

  Widget _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot, Function buildRow,
      {CollectionReference reference}) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          print('i:$i');
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          print('index:$index');
          if (index < snapshot.length) {
            if(!checkList.containsKey(snapshot.elementAt(index).documentID)) {
              checkList[snapshot.elementAt(index).documentID] = false;
            }
            return buildRow(context, snapshot.elementAt(index),
                reference: reference);
          } else if(widget.checkable && index == snapshot.length) {
            return FlatButton(onPressed:(){},child:Text('완료'));
          }
          return null;
        });
  }

  Function _buildFriend(Function removeFriend, Function acceptFriend) {
    Widget buildRow(BuildContext context, DocumentSnapshot friend,
        {CollectionReference reference}) {
      return widget.checkable
          ? CheckboxListTile(
              value: checkList[friend.documentID],
              onChanged: (bool value) {
                setState(() {
                  checkList[friend.documentID] = value;
                });
              },
              secondary: Icon(Icons.person),
              title: Text(friend['name']),
              subtitle: Text(friend['email']),
            )
          : ListTile(
              leading: Icon(Icons.person),
              title: Text(friend['name']),
              subtitle: Text(friend['email']),
              trailing: friendStatus(friend['status'], friend.documentID,
                  removeFriend, acceptFriend));
    }

    return buildRow;
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
              return CircularProgressIndicator();
            default:
              return snapshot.hasData
                  ? _buildList(
                      context,
                      snapshot.data.documents,
                      _buildFriend(Provider.of<Store>(context).removeFriend,
                          Provider.of<Store>(context).acceptFriend))
                  : Container();
          }
        });
  }
}
