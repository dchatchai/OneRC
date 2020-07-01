import 'package:flutter/material.dart';
import 'package:onerc/utility/my_style.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyStyle().showLogo(),
            MyStyle().showTextH1('Royal Can'),
            userForm(),
          ],
        ),
      ),
    );
  }

  Widget userForm() => Container(
        width: 250,
        child: TextField(),
      );
}
