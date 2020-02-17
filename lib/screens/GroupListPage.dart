import "package:flutter/material.dart";

class GroupListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FriendListPage"),
      ),
      drawer:Drawer(
        child:ListView(
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
              leading: Icon(Icons.calendar_today),
              title: Text('내 계획'),
            ),
            ListTile(
              leading: Icon(Icons.supervisor_account),
              title: Text('친구 목록'),
            ),
            ListTile(
              leading: Icon(Icons.group_work),
              title: Text('모임 목록'),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.group),
              title: Text('우용동언'),
              trailing: Icon(Icons.delete)
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
