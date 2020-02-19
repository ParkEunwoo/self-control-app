import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:self_control/firebase/admob.dart';
import 'package:table_calendar/table_calendar.dart';

class DetailPage extends StatelessWidget {
  DocumentReference plan;

  DetailPage({this.plan});

  @override
  Widget build(BuildContext context) {
    AdMob.instance.showBanner();
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
                return Content(context, snapshot.data);
            }
          },
        ));
  }

  Widget Content(BuildContext context, DocumentSnapshot data) {
    return Column(
      children: <Widget>[
        Text(data['title'], style: TextStyle(fontSize: 20)),
        RemainingTime(period: data['period']),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('1${data['period']}'),
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

  _RemainingTimeState(String period) {
    this.period = period;
    now = DateTime.now();
    switch (period) {
      case '주':
        goal = DateTime.utc(now.year, now.month,
            now.day + (now.weekday > 0 ? 7 - now.weekday : 0), 23, 59, 59);
        break;
      case '일':
      default:
        goal = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
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
    return Text(
        '${week()}${goal.hour - now.hour}시간 ${goal.minute - now.minute}분 ${goal.second - now.second}초');
  }

  String week() {
    if (period == '일') return '';
    return '${goal.day - now.day}일';
  }
}

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController = CalendarController();
  Map<DateTime, List<int>> _events;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
        calendarController: _calendarController,
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: (date, events) {
          setState(() {
            _events[date] = [3];
          });
        },
        builders: CalendarBuilders(
          selectedDayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Colors.white),
              )),
          todayDayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Colors.white),
              )),
          markersBuilder: (context, date, events, holidays) {
            final children = <Widget>[];

            if (events.isNotEmpty) {
              children.add(Container(
                child: Center(
                    child: Text('${events[0]}',
                        style: TextStyle(color: Colors.white))),
                decoration: BoxDecoration(
                    color: isSuccess() ? Colors.lightBlue : Colors.deepOrange),
                height: 16.0,
              ));
            }

            return children;
          },
        ),
        events: _events);
  }

  bool isSuccess() {
    return true;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
}
