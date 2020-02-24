import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_control/firebase/store.dart';

import 'DetailPage.dart';

const int MAIN_PAGE = 0;
const int FRIEND_PAGE = 1;
const int GROUP_PAGE = 2;

class ListPage extends StatelessWidget {
  final int page;

  ListPage({Key key, this.page}) : super(key: key);

  Widget _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot, Function buildRow,
      {CollectionReference reference}) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index < snapshot.length) {
            return buildRow(context, snapshot.elementAt(index),
                reference: reference);
          }
          return null;
        });
  }

  Widget _buildPlan(BuildContext context, DocumentSnapshot plan,
      {CollectionReference reference}) {
    if (plan['goalDate'] != null) {
      if (DateTime.now().isAfter(DateTime.parse(plan['goalDate']))) {
        reference.document(plan.documentID).updateData(
            {"goalDate": '${Store.getGoalTime(plan['period'])}', "now": 0});
      }
    }
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailPage(plan: reference.document(plan.documentID))),
        );
      },
      leading: Icon(Icons.star),
      title: Text(plan['title'], style: TextStyle(fontSize: 26)),
      trailing: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('${plan['now']}/${plan['times']}${plan['timesUnit']}',
            style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Function _buildFriend(Function removeFriend, Function acceptFriend) {
    Widget buildRow(BuildContext context, DocumentSnapshot friend,
        {CollectionReference reference}) {
      return ListTile(
          leading: Icon(Icons.person),
          title: Text(friend['name']),
          subtitle: Text(friend['email']),
          trailing: friendStatus(
              friend['status'], friend.documentID, removeFriend, acceptFriend));
    }

    return buildRow;
  }

  Widget friendStatus(
      String status, String id, Function removeFriend, Function acceptFriend) {
    switch (status) {
      case 'request':
        return FlatButton(onPressed: null, child: Text('요청 보냄', style:TextStyle(fontSize: 12)));
      case 'respond':
        return FlatButton(
            child: Text('수락 하기', style:TextStyle(fontSize: 12)),
            textTheme: ButtonTextTheme.primary,
            color: Colors.primaries[5],
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
    switch (page) {
      case MAIN_PAGE:
        return StreamBuilder<QuerySnapshot>(
          stream: Provider.of<Store>(context).plans.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return LinearProgressIndicator();
              default:
                return snapshot.hasData
                    ? _buildList(context, snapshot.data.documents, _buildPlan,
                    reference: Provider.of<Store>(context).plans)
                    : Container();
            }
          },
        );
      case FRIEND_PAGE:
        return StreamBuilder<QuerySnapshot>(
          stream: Provider.of<Store>(context).friends.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          },
        );
      case GROUP_PAGE:
      default:
        return Container();
    }
  }
}
