import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class AuthPage extends StatelessWidget {
  final Widget svg = SvgPicture.asset(
    'assets/icons8-google.svg',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AuthPage"),
      ),
      body: Center(
          child: FlatButton(
              onPressed: () {},
              child: Card(
                elevation: 2,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 20),
                    new SvgPicture.asset('assets/icons8-google.svg'),
                    SizedBox(width: 20),
                    Text("구글로 로그인", style: TextStyle(fontSize: 24)),
                  ],
                ),
              ))),
    );
  }
}

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          )
        ]));
  }
}
