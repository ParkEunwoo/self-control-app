import 'package:flutter/foundation.dart';
import 'package:self_control/data/plan.dart';

class PlanList with ChangeNotifier{
  List<Plan> _planList = [
    Plan(id:'1',title: "금연", period:1, periodUnit:'주', times:30, timesUnit:'개피', isPositive: false),
    Plan(id:'2',title: "금딸", period:1, periodUnit:'주', times:1, timesUnit:'회', isPositive: false),
    Plan(id:'3',title: "운동", period:1, periodUnit:'일', times:2, timesUnit:'시간', isPositive: true),
    Plan(id:'4',title: "공부", period:1, periodUnit:'일', times:3, timesUnit:'시간', isPositive: true),
    Plan(id:'5',title: "절약", period:1, periodUnit:'주', times:50000, timesUnit:'원', isPositive: false),
  ];

  List<Plan> get plans => _planList;
  int get length => _planList.length;
  int getIndex(String id) => _planList.indexWhere((plan) => id == plan.id);
  Plan getItemById(String id) => _planList.elementAt(getIndex(id));

  Plan getItemByIndex(int index) => _planList.elementAt(index);
  void addItem(Plan plan) {
    _planList.add(plan);
    notifyListeners();
  }
  void deleteItem(String id) {
    _planList.removeAt(getIndex(id));
    notifyListeners();
  }
}
