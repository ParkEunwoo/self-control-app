import 'dart:async';

import 'package:flutter/material.dart';

class RemainingTime extends StatefulWidget {
  String period;
  DateTime goal;

  RemainingTime({this.period, this.goal});

  @override
  _RemainingTimeState createState() => _RemainingTimeState();
}

class _RemainingTimeState extends State<RemainingTime> {
  DateTime now = DateTime.now();
  DateTime goal;
  String period;

  @override
  void initState() {
    goal = widget.goal;
    period = widget.period;
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {
        now = DateTime.now(); // or BinaryTime see next step
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        '${week()}${goal.hour - now.hour}시간 ${goal.minute - now.minute}분 ${goal.second - now.second}초');
  }

  String week() {
    if (period == '일') return '';
    return '${goal.day - now.day}일';
  }
}
