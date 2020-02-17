import "package:flutter/material.dart";
import 'package:table_calendar/table_calendar.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("DetailPage"),
        ),
        body: Column(
          children: <Widget>[
            Text("금연", style: TextStyle(fontSize: 20)),
            Text("4일 13시간 32분 02초"),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
              Text("1주"),
              Text("4/30개피"),
            ]),
            Calendar()
          ],
        ));
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
