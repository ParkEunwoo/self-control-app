import "package:flutter/material.dart";

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
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text('친구선택'),
          ),
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
