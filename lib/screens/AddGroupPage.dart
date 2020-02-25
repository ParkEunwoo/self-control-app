import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:self_control/data/group.dart';
import 'package:self_control/firebase/admob.dart';
import 'package:self_control/firebase/store.dart';

class AddGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AdMob.instance.showBanner();
    return Scaffold(
        appBar: AppBar(
          title: Text("AddGroupPage"),
        ),
        body: Center(
            child: Card(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Provider.of<Store>(context)
                        .friends
                        .where("status", isEqualTo: "accepted")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return CircularProgressIndicator();
                        default:
                          return snapshot.hasData
                              ? GroupForm(snapshot: snapshot.data.documents)
                              : Container();
                      }
                    }))));
  }
}

class GroupForm extends StatefulWidget {
  List<DocumentSnapshot> snapshot;

  GroupForm({Key key, this.snapshot}) : super(key: key);

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  Map<String, bool> checkList = {};
  Map<String, String> friendName = {};

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index < snapshot.length) {
            if (!checkList.containsKey(snapshot.elementAt(index).documentID)) {
              checkList[snapshot.elementAt(index).documentID] = false;
            }
            if (!friendName.containsKey(snapshot.elementAt(index).documentID)) {
              friendName[snapshot.elementAt(index).documentID] =
                  snapshot.elementAt(index)['name'];
            }
            return _buildRow(context, snapshot.elementAt(index));
          }
          return null;
        });
  }

  Widget _buildRow(BuildContext context, DocumentSnapshot friend) {
    return CheckboxListTile(
      value: checkList[friend.documentID],
      onChanged: (bool value) {
        setState(() {
          checkList[friend.documentID] = value;
        });
      },
      secondary: Icon(Icons.person),
      title: Text(friend['name']),
      subtitle: Text(friend['email']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: titleController,
              decoration:
                  InputDecoration(icon: Icon(Icons.people), labelText: "모임이름"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Expanded(child: _buildList(context, widget.snapshot)),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Map<String, String> friends = {};
                checkList.forEach((id, checked) {
                  if (checked) {
                    friends[id] = friendName[id];
                  }
                });
                Navigator.pop(context,
                    Group(title: titleController.text, friends: friends));
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text('Submit'),
          )
          // Add TextFormFields and RaisedButton here.
        ]));
  }
}

class CheckFriendList extends StatefulWidget {
  CheckFriendList({Key key}) : super(key: key);

  @override
  _CheckFriendListState createState() => _CheckFriendListState();
}

class _CheckFriendListState extends State<CheckFriendList> {
  Map<String, bool> checkList = {};

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index < snapshot.length) {
            if (!checkList.containsKey(snapshot.elementAt(index).documentID)) {
              checkList[snapshot.elementAt(index).documentID] = false;
            }
            return _buildRow(context, snapshot.elementAt(index));
          }
          return null;
        });
  }

  Widget _buildRow(BuildContext context, DocumentSnapshot friend) {
    return CheckboxListTile(
      value: checkList[friend.documentID],
      onChanged: (bool value) {
        setState(() {
          checkList[friend.documentID] = value;
        });
      },
      secondary: Icon(Icons.person),
      title: Text(friend['name']),
      subtitle: Text(friend['email']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Provider.of<Store>(context)
            .friends
            .where("status", isEqualTo: "accepted")
            .snapshots(),
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
        });
  }
}
