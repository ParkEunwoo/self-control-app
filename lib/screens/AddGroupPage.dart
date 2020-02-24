import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:self_control/firebase/store.dart';

class AddGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AddGroupPage"),
        ),
        body: Center(child: Card(child: GroupForm())));
  }
}

class GroupForm extends StatefulWidget {
  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final periodController = TextEditingController();
  final timesController = TextEditingController();
  final unitController = TextEditingController();
  String dropdownValue = '주';

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
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
          CheckFriendList(),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
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

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      {CollectionReference reference}) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index < snapshot.length) {
            if (!checkList.containsKey(snapshot.elementAt(index).documentID)) {
              checkList[snapshot.elementAt(index).documentID] = false;
            }
            return _buildRow(context, snapshot.elementAt(index),
                reference: reference);
          }
          return null;
        });
  }

  Widget _buildRow(BuildContext context, DocumentSnapshot friend,
      {CollectionReference reference}) {
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
