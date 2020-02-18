import 'package:flutter/foundation.dart';

class Plan {
  String title;
  int period;
  String periodUnit;
  int times;
  String timesUnit;
  bool isPositive;

  int now = 0;

  Plan({@required this.title,
    @required this.period,
    @required this.periodUnit,
    @required this.times,
    @required this.timesUnit,
    @required this.isPositive});

}