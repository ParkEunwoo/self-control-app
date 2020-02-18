import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:self_control/screens/AuthPage.dart';
import 'package:self_control/screens/MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream:FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if(snapshot.data == null){
          return AuthPage();
        }
        return MainPage(uid:snapshot.data.uid);
      }
    );
  }
}
