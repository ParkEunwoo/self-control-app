import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_control/firebase/store.dart';

import 'DetailPage.dart';

class PlanList extends StatelessWidget {
  PlanList({Key key}) : super(key: key);

  Future<void> setPlanList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    Map<String, String> planList = {};
    snapshot.forEach((plan) {
      planList[plan.documentID] = plan['title'].toString();
    });
    Provider.of<Store>(context).setPlanList(planList);
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index < snapshot.length) {
            return _buildRow(context, snapshot.elementAt(index));
          }
          return null;
        });
  }

  Widget _buildRow(BuildContext context, DocumentSnapshot plan) {
    if (plan['goalDate'] != null) {
      if (DateTime.now().isAfter(DateTime.parse(plan['goalDate']))) {
        Provider.of<Store>(context).plans.document(plan.documentID).updateData(
            {"goalDate": '${Store.getGoalTime(plan['period'])}', "now": 0});
      }
    }
    return Dismissible(
      key: Key(plan.documentID),
      onDismissed: (direction) {
        Provider.of<Store>(context, listen: false).removePlan(plan.documentID);
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("${plan['title']} dismissed")));
      },
      background: Container(color: Colors.red),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(id: plan.documentID)),
          );
        },
        leading: Icon(Icons.star),
        title: Text(plan['title'], style: TextStyle(fontSize: 26)),
        trailing: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('${plan['now']}/${plan['times']}${plan['timesUnit']}',
              style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Provider.of<Store>(context).plans.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            setPlanList(context, snapshot.data.documents);
            return snapshot.hasData
                ? _buildList(context, snapshot.data.documents)
                : Container();
        }
      },
    );
  }
}
