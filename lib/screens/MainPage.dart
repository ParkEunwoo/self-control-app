import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:self_control/data/friend.dart';
import 'package:self_control/data/plan.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("MainPage"),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
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
      ),
      body: ListPage(page: page),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              switch (page) {
                case MAIN_PAGE:
                  return AddPlanPage();
                case FRIEND_PAGE:
                  return AddFriendPage();
                case GROUP_PAGE:
                  return AddGroupPage();
                default:
                  return AddPlanPage();
              }
            }),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget FriendList() {
    return ListView(
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.person),
            title: Text('권기남'),
            trailing: Icon(Icons.delete)),
        ListTile(
            onTap: () {},
            leading: Icon(Icons.person),
            title: Text('권기남'),
            trailing: Icon(Icons.check_box)),
        ListTile(
            leading: Icon(Icons.person),
            title: Text('권기남'),
            trailing: Icon(Icons.delete)),
        ListTile(
            leading: Icon(Icons.person),
            title: Text('권기남'),
            trailing: Icon(Icons.delete)),
      ],
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

  Widget _buildList(BuildContext context, List list, Function buildRow) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          print('item: $i');
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index < list.length) {
            return buildRow(context, list.elementAt(index));
          }
          return null;
        });
  }

  Widget _buildPlan(BuildContext context, DocumentSnapshot plan) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage()),
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

  Widget _buildFriend(BuildContext context, Friend friend) {
    return ListTile(
        leading: Icon(Icons.person),
        title: Text(friend.name),
        trailing: Icon(Icons.delete));
  }

  @override
  Widget build(BuildContext context) {
    switch (page) {
      case MAIN_PAGE:
        return StreamBuilder<QuerySnapshot>(
          stream: Provider.of<Store>(context, listen: false).plans.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return LinearProgressIndicator();
              default:
                return ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                    return _buildPlan(context, document);
                  }).toList(),
                );
            }
          },
        );
      case FRIEND_PAGE:
      case GROUP_PAGE:
      default:
        return Container();
    }
  }
}
