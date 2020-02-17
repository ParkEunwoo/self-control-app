import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class AuthPage extends StatelessWidget {
  final Widget svg = SvgPicture.asset(
    'assets/icons8-google.svg',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AuthPage"),
      ),
      body: Center(
          child: FlatButton(
              onPressed: () {},
              child: Card(
                elevation: 2,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 20),
                    new SvgPicture.asset('assets/icons8-google.svg'),
                    SizedBox(width: 20),
                    Text("구글로 로그인", style: TextStyle(fontSize: 24)),
                  ],
                ),
              ))),
    );
  }
}
