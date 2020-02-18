import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:self_control/data/plan.dart';
import 'package:self_control/firebase/store.dart';

class AddPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AddPage"),
        ),
        body: Center(child: Card(child: AddForm())));
  }
}

class AddForm extends StatefulWidget {
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final timesController = TextEditingController();
  final unitController = TextEditingController();
  String period = '주';
  bool isPositive = false;

  @override
  void dispose() {
    titleController.dispose();
    timesController.dispose();
    unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0),
            child: TextFormField(
              controller: titleController,
              decoration:
                  InputDecoration(icon: Icon(Icons.done), labelText: "목표"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16.0),
                  child: TextFormField(
                    controller: timesController,
                    decoration:
                        InputDecoration(icon: Icon(Icons.history), labelText: "횟수"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:16.0),
                child: DropdownButton<String>(
                  value: period,
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (value) {
                    setState(() {
                      period = value;
                    });
                  },
                  items: <String>['주', '일']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0),
            child: TextFormField(
              controller: unitController,
              decoration:
                  InputDecoration(icon: Icon(Icons.extension), labelText: "단위"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          CheckboxListTile(
            secondary: Icon(Icons.thumb_up),
            title:Text('긍정'),
              value: isPositive,
              onChanged: (value) {
                setState(() {
                  isPositive = value;
                });
              }),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Navigator.pop(
                    context,
                    Plan(
                        title: titleController.text,
                        period: period,
                        times: int.parse(timesController.text),
                        timesUnit: unitController.text,
                        isPositive: isPositive));
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text('추가하기'),
          )
          // Add TextFormFields and RaisedButton here.
        ]));
  }
}
