import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:self_control/data/group.dart';
import 'package:self_control/data/plan.dart';
import 'package:self_control/firebase/admob.dart';
import 'package:self_control/firebase/auth.dart';
import 'package:self_control/firebase/store.dart';
import 'package:self_control/screens/AddPlanPage.dart';
import 'package:self_control/screens/GroupList.dart';

import 'AddFriendPage.dart';
import 'AddGroupPage.dart';
import 'FriendList.dart';
import 'PlanList.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page();
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
        body: _buildBody(),
        floatingActionButton: Align(
            child: FloatingActionButton(
              onPressed: () async {
                switch (page) {
                  case FRIEND_PAGE:
                    String email = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddFriendPage()),
                    );
                    if (email != null) {
                      Provider.of<Store>(context, listen: false)
                          .addFriend(email);
                    }

                    break;
                  case GROUP_PAGE:
                    Group group = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddGroupPage()),
                    );
                    if(group != null) {
                      Provider.of<Store>(context, listen: false).addGroup(group);
                    }

                    break;
                  case MAIN_PAGE:
                  default:
                    Plan plan = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPlanPage()),
                    );
                    if (plan != null) {
                      Provider.of<Store>(context, listen: false).addPlan(plan);
                    }
                    break;
                }
              },
              tooltip: 'Add',
              child: Icon(Icons.add),
            ),
            alignment: Alignment(1, 0.7)));
  }

  Widget _buildBody() {
    switch (page) {
      case FRIEND_PAGE: return FriendList();
      case GROUP_PAGE: return GroupList();
      case MAIN_PAGE:
      default: return PlanList();
    }
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

}
