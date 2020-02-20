import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
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
                return Content(context, snapshot.data, plan);
            }
          },
        ));
  }

  Widget Content(
      BuildContext context, DocumentSnapshot data, DocumentReference plan) {
    return Column(
      children: <Widget>[
        Text(data['title'], style: TextStyle(fontSize: 20)),
        RemainingTime(period: data['period'], goal: data['goalDate'].toDate()),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('1${data['period']}'),
              Text("${data['now']}/${data['times']}${data['timesUnit']}"),
            ]),
        Calendar(
            startDate: data['startDate'].toDate(),
            period: data['period'],
            times: data['times'],
            now: data['now'],
            plan: plan)
      ],
    );
  }
}

class RemainingTime extends StatefulWidget {
  String period;
  DateTime goal;

  RemainingTime({this.period, this.goal});

  @override
  _RemainingTimeState createState() => _RemainingTimeState(period:period, goal:goal);
}

class _RemainingTimeState extends State<RemainingTime> {
  DateTime now;
  DateTime goal;
  String period;

  _RemainingTimeState({this.period, this.goal});

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
  DateTime startDate;
  String period;
  int times;
  int now;
  DocumentReference plan;

  Calendar({this.startDate, this.period, this.times, this.now, this.plan});

  @override
  _CalendarState createState() => _CalendarState(
      startDate: startDate, period: period, times: times, now: now, plan: plan);
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController;
  TextEditingController _eventController;
  Map<DateTime, List<dynamic>> _events;
  DateTime startDate;
  String period;
  int times;
  int now;
  DocumentReference plan;
  CollectionReference archives;

  _CalendarState(
      {this.startDate, this.period, this.times, this.now, this.plan}) {
    archives = plan.collection('archives');
    _events = {};
    List<DateTime> list = List<DateTime>.generate(
        DateTime.now().difference(startDate).inDays,
        (index) => DateTime.parse('${startDate.toString().substring(0, 10)} 12')
            .add(Duration(days: index)));

    list.forEach((date) {
      _events[date] = [0, true];
    });
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _eventController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: archives.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return LinearProgressIndicator();
          default:
            setEvents(snapshot.data.documents);
            return _buildCalendar(context);
        }
      },
    );
  }

  void setEvents(List<DocumentSnapshot> dates) {
    dates.forEach((snapshot) {
      DateTime date = DateTime.parse(snapshot.documentID);
      if(snapshot['amount'] != null){
        _events[date] = [snapshot['amount'], snapshot['success']];
      } else {
        _events[date] = [0, snapshot['success']];
      }
    });
  }

  Widget _buildCalendar(BuildContext context) {
    return TableCalendar(
        calendarController: _calendarController,
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: (date, events) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: TextField(
                      controller: _eventController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Save"),
                        onPressed: () {
                          if (_eventController.text.isEmpty) return;
                          int amount = int.parse(_eventController.text);
                          now += amount;
                          plan.updateData({'now': now});
                          archives
                              .document(date.toString().substring(0, 13))
                              .setData({"amount": amount, 'success': true});
                          if (now > times) {
                            DateTime startWeek =
                                date.subtract(Duration(days: date.weekday - 1));
                            for(int i = 0; i<7;i++) {
                              archives
                                  .document('${startWeek.add(Duration(days:i)).toString().substring(0, 10)} 12')
                                  .updateData({'success': false});
                            }
                          }
                          _eventController.clear();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ));
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
                child: events.first == 0
                    ? null
                    : Center(
                        child: Text('${events.first}',
                            style: TextStyle(color: Colors.white))),
                decoration: BoxDecoration(
                    color: events.last ? Colors.lightBlue : Colors.deepOrange),
                height: 16.0,
              ));
            }

            return children;
          },
        ),
        events: _events);
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _eventController.dispose();
    super.dispose();
  }
}
