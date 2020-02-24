import "package:flutter/material.dart";
import 'package:self_control/firebase/auth.dart';


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
  final nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: _formKey, child: InputField());
  }

  Widget InputField() {
    if (isLogin) {
      return Column(children: <Widget>[
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
          decoration:
              InputDecoration(icon: Icon(Icons.vpn_key), labelText: "password"),
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
              Auth.signIn(
                  email: emailController.text,
                  password: passwordController.text);
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Processing Data')));
            }
          },
          child: Text("로그인"),
        ),
        GestureDetector(
            onTap: () {
              Auth.resetPassword(emailController.text);
            },
            child: Text("비밀번호 찾기")),
        GestureDetector(
            onTap: () {
              setState(() {
                isLogin = !isLogin;
              });
            },
            child: Text("회원가입하기"))
      ]);
    } else {
      return Column(children: <Widget>[
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
          decoration:
              InputDecoration(icon: Icon(Icons.vpn_key), labelText: "password"),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        TextFormField(
            controller: nameController,
            decoration: InputDecoration(
                icon: Icon(Icons.perm_identity), labelText: "name"),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            }),
        RaisedButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Auth.createUser(
                  email: emailController.text,
                  password: passwordController.text,
                  name: nameController.text);
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Processing Data')));
            }
          },
          child: Text("회원가입"),
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                isLogin = !isLogin;
              });
            },
            child: Text("로그인하기"))
      ]);
    }
  }
}
