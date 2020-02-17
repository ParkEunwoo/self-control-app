import "package:flutter/material.dart";
import 'package:self_control/firebase/auth.dart';

import 'MainPage.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AuthPage"),
        ),
        body: Center(
          child: Card(child: AuthForm()),
        ));
  }
}

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                icon: Icon(Icons.account_circle), labelText: "email"),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
                icon: Icon(Icons.vpn_key), labelText: "password"),
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
                if(isLogin){
                  Auth.signIn(
                      email: emailController.text,
                      password: passwordController.text);
                }
                else {
                  Auth.createUser(email:emailController.text, password:passwordController.text);
                }
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text(isLogin ? "로그인" : "회원가입"),
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  print(isLogin);
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin ? "회원가입하기" : "로그인하기"))
        ]));
  }
}
