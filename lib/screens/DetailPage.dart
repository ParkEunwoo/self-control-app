import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:table_calendar/table_calendar.dart';

class DetailPage extends StatelessWidget {
  DocumentReference plan;

  DetailPage({this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("DetailPage"),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: plan.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return LinearProgressIndicator();
              default:
                return Content(
                    context, snapshot.data);
            }
          },
        ));
  }

  Widget Content(BuildContext context, DocumentSnapshot data) {
    return Column(
      children: <Widget>[
        Text(data['title'], style: TextStyle(fontSize: 20)),
        RemainingTime(period:data['periodUnit']),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('${data['period']}${data['periodUnit']}'),
              Text("${data['now']}/${data['times']}${data['timesUnit']}"),
            ]),
        Calendar()
      ],
    );
  }
}

class RemainingTime extends StatefulWidget {
  String period;
  RemainingTime({this.period});

  @override
  _RemainingTimeState createState() => _RemainingTimeState(period);
}
class _RemainingTimeState extends State<RemainingTime> {
  DateTime now;
  DateTime goal;
  String period;
  _RemainingTimeState(String period){
    this.period = period;
    now = DateTime.now();
    switch(period) {
      case '주': goal = DateTime.utc(now.year, now.month, now.day+(now.weekday > 0 ? 7-now.weekday : 0), 23, 59, 59); break;
      case '일':
      default: goal=DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
    }
  }
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {
        now = DateTime.now(); // or BinaryTime see next step
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Text('${week()}${goal.hour - now.hour}시간 ${goal.minute - now.minute}분 ${goal.second - now.second}초');
  }
  String week() {
    if(period=='일') return '';
    return '${goal.day - now.day}일';
  }
}


class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(calendarController: _calendarController);
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
}
