import "package:flutter/material.dart";
import 'package:self_control/screens/FriendListPage.dart';

class AddFriendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AddFriendPage"),
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
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            controller: emailController,
            decoration:
            InputDecoration(icon: Icon(Icons.account_circle), labelText: "email"),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Navigator.pop(context, emailController.text);
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
