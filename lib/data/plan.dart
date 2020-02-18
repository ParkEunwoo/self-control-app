
class Plan {
  String id;
  String title;
  int period;
  String periodUnit;
  int times;
  String timesUnit;
  bool isPositive;

  int now = 0;

  Plan({this.id, this.title, this.period, this.periodUnit, this.times, this.timesUnit, this.isPositive});

}