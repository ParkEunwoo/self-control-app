import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:self_control/data/plan.dart';
import 'package:self_control/firebase/admob.dart';
import 'package:self_control/firebase/auth.dart';
import 'package:self_control/firebase/store.dart';
import 'package:self_control/screens/AddPlanPage.dart';

import 'AddFriendPage.dart';
import 'AddGroupPage.dart';
import 'DetailPage.dart';

class MainPage extends StatelessWidget {
  String uid;

  MainPage({this.uid});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Store>(
        create: (context) => Store(uid), child: Page());
  }
}

const int MAIN_PAGE = 0;
const int FRIEND_PAGE = 1;
const int GROUP_PAGE = 2;

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    AdMob.instance.showBanner();

    return Scaffold(
        appBar: AppBar(
          title: Text("MainPage"),
        ),
        drawer: _buildDrawer(),
        body: ListPage(page: page),
        floatingActionButton: Align(
            child: FloatingActionButton(
              onPressed: () async {
                switch (page) {
                  case FRIEND_PAGE:
                    String email = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddFriendPage()),
                    );
                    Provider.of<Store>(context, listen: false).addFriend(email);
                    break;
                  case GROUP_PAGE:
                    Plan plan = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddGroupPage()),
                    );
                    Provider.of<Store>(context, listen: false).addPlan(plan);
                    break;
                  case MAIN_PAGE:
                  default:
                    Plan plan = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPlanPage()),
                    );
                    Provider.of<Store>(context, listen: false).addPlan(plan);
                    break;
                }
              },
              tooltip: 'Add',
              child: Icon(Icons.add),
            ),
            alignment: Alignment(1, 0.7)));
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
                child: Text('Self Control',
                    style: TextStyle(fontSize: 24, color: Colors.white))),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                page = MAIN_PAGE;
              });
              Navigator.pop(context);
            },
            leading: Icon(Icons.calendar_today),
            title: Text('내 계획'),
          ),
          ListTile(
            onTap: () {
              setState(() {
                page = FRIEND_PAGE;
              });
              Navigator.pop(context);
            },
            leading: Icon(Icons.supervisor_account),
            title: Text('친구 목록'),
          ),
          ListTile(
            onTap: () {
              setState(() {
                page = GROUP_PAGE;
              });
              Navigator.pop(context);
            },
            leading: Icon(Icons.group_work),
            title: Text('모임 목록'),
          ),
          ListTile(
            onTap: () {
              Auth.signOut();
            },
            leading: Icon(Icons.account_circle),
            title: Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  Widget GroupList() {
    return ListView(
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.group),
            title: Text('우용동언'),
            trailing: Icon(Icons.delete)),
      ],
    );
  }
}

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
      if (DateTime.now().isAfter(plan['goalDate'].toDate())) {
        reference.document(plan.documentID).updateData(
            {"goalDate": Timestamp.fromDate(Store.getGoalTime(plan['period'])), "now": 0});
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

  Function _buildFriend(Function removeFriend) {
    Widget buildRow(BuildContext context, DocumentSnapshot friend,
        {CollectionReference reference}) {
      return ListTile(
          leading: Icon(Icons.person),
          title: Text(friend['name']),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                removeFriend(friend.documentID);
              }));
    }

    return buildRow;
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
                return _buildList(context, snapshot.data.documents, _buildPlan,
                    reference: Provider.of<Store>(context).plans);
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
                return LinearProgressIndicator();
              default:
                return _buildList(context, snapshot.data.documents,
                    _buildFriend(Provider.of<Store>(context).removeFriend));
            }
          },
        );
      case GROUP_PAGE:
      default:
        return Container();
    }
  }
}
