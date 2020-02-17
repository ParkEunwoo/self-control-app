import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class MainPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.view_headline),
        title: Text("MainPage"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.star),
            title: Text('금연', style:TextStyle(fontSize:26)),
            trailing: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('6/30개피', style:TextStyle(fontSize:16)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('금딸', style:TextStyle(fontSize:26)),
            trailing: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('1/1딸', style:TextStyle(fontSize:16)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('운동', style:TextStyle(fontSize:26)),
            trailing: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('1/2시간', style:TextStyle(fontSize:16)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('공부', style:TextStyle(fontSize:26)),
            trailing: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('1/3시간', style:TextStyle(fontSize:16)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('절약', style:TextStyle(fontSize:26)),
            trailing: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('8700/50000원', style:TextStyle(fontSize:16)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
