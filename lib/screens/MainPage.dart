import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import 'package:self_control/screens/AddPlanPage.dart';

import 'AddGroupPage.dart';
import 'DetailPage.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page();
  }
}

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
                  page = 0;
                });
              },
              leading: Icon(Icons.calendar_today),
              title: Text('내 계획'),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  page = 1;
                });
              },
              leading: Icon(Icons.supervisor_account),
              title: Text('친구 목록'),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  page = 2;
                });
              },
              leading: Icon(Icons.group_work),
              title: Text('모임 목록'),
            ),
          ],
        ),
      ),
      body: Body(page),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              switch (page) {
                case 0:
                  AddPlanPage(); break;
                case 1:
                  null; break;
                case 2:
                  AddGroupPage(); break;
              }
            }),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget Body(int page) {
    switch (page) {
      case 0:
        return PlanList();
      case 1:
        return FriendList();
      case 2:
        return GroupList();
    }
  }

  Widget PlanList() {
    return ListView(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailPage()),
            );
          },
          leading: Icon(Icons.star),
          title: Text('금연', style: TextStyle(fontSize: 26)),
          trailing: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('6/30개피', style: TextStyle(fontSize: 16)),
          ),
        ),
        ListTile(
          leading: Icon(Icons.star),
          title: Text('금딸', style: TextStyle(fontSize: 26)),
          trailing: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('1/1딸', style: TextStyle(fontSize: 16)),
          ),
        ),
        ListTile(
          leading: Icon(Icons.star),
          title: Text('운동', style: TextStyle(fontSize: 26)),
          trailing: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('1/2시간', style: TextStyle(fontSize: 16)),
          ),
        ),
        ListTile(
          leading: Icon(Icons.star),
          title: Text('공부', style: TextStyle(fontSize: 26)),
          trailing: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('1/3시간', style: TextStyle(fontSize: 16)),
          ),
        ),
        ListTile(
          leading: Icon(Icons.star),
          title: Text('절약', style: TextStyle(fontSize: 26)),
          trailing: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('8700/50000원', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
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
