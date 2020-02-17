import 'package:flutter/material.dart';
import 'package:self_control/screens/AddGroupPage.dart';
import 'package:self_control/screens/AddPlanPage.dart';
import 'package:self_control/screens/AuthPage.dart';
import 'package:self_control/screens/DetailPage.dart';
import 'package:self_control/screens/FriendListPage.dart';
import 'package:self_control/screens/GroupListPage.dart';
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
      home: AuthPage(),
    );
  }
}
