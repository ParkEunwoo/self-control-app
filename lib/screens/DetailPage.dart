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
                return CircularProgressIndicator();
              default:
                return snapshot.hasData
                    ? Content(context, snapshot.data, plan)
                    : Container();
            }
          },
        ));
  }

  Widget Content(
      BuildContext context, DocumentSnapshot data, DocumentReference plan) {
    return Column(
      children: <Widget>[
        Text(data['title'], style: TextStyle(fontSize: 20)),
        RemainingTime(
            period: data['period'], goal: DateTime.parse(data['goalDate'])),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('1${data['period']}'),
              Text("${data['now']}/${data['times']}${data['timesUnit']}"),
            ]),
        Calendar(
            startDate: data['startDate'],
            period: data['period'],
            times: data['times'],
            now: data['now'],
            isPositive: data['isPositive'],
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
  _RemainingTimeState createState() =>
      _RemainingTimeState(period: period, goal: goal);
}

class _RemainingTimeState extends State<RemainingTime> {
  DateTime now = DateTime.now();
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
  String startDate;
  String period;
  int times;
  int now;
  bool isPositive;
  DocumentReference plan;

  Calendar(
      {this.startDate,
      this.period,
      this.times,
      this.now,
      this.isPositive,
      this.plan});

  @override
  _CalendarState createState() => _CalendarState(
      startDate: startDate,
      period: period,
      times: times,
      now: now,
      isPositive: isPositive,
      plan: plan);
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController;
  TextEditingController _eventController;
  Map<DateTime, List<dynamic>> _events;
  String startDate;
  String period;
  int times;
  int now;
  bool isPositive;
  DocumentReference plan;
  CollectionReference archives;

  _CalendarState(
      {this.startDate,
      this.period,
      this.times,
      this.now,
      this.isPositive,
      this.plan}) {
    archives = plan.collection('archives');

    _events = {};
    List<DateTime> list = List<DateTime>.generate(
        DateTime.now().difference(DateTime.parse(startDate)).inDays,
        (index) => DateTime.parse(startDate).add(Duration(days: index)));

    list.forEach((date) {
      _events[date] = [0, !isPositive];
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
      if (snapshot['amount'] != null) {
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

          if(isToday(date)){

            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('입력'),
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
                        if (period == '주') {
                          now += amount;
                          archives
                              .document(date.toString().substring(0, 13))
                              .setData(
                              {"amount": amount, 'success': !isPositive});
                          if ((!isPositive && now > times) ||
                              (isPositive && now >= times)) {
                            DateTime startWeek = date
                                .subtract(Duration(days: date.weekday - 1));
                            for (int i = 0; i < 7; i++) {
                              archives
                                  .document(
                                  '${startWeek.add(Duration(days: i)).toString().substring(0, 10)} 12')
                                  .updateData({'success': isPositive});
                            }
                          }
                        } else {
                          now = amount;
                          archives
                              .document(date.toString().substring(0, 13))
                              .setData(
                              {"amount": amount, 'success': isSuccess()});
                        }
                        plan.updateData({'now': now});
                        _eventController.clear();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ));
          }
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

  bool isToday(DateTime date){
    DateTime today = DateTime.now();
    int diffDays = date.difference(today).inDays;
    if(diffDays == 0 && date.day == today.day){
      return true;
    }
    return false;
  }

  bool isSuccess() {
    if (!isPositive && now > times) {
      return false;
    } else if (isPositive && now < times) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _eventController.dispose();
    super.dispose();
  }
}
