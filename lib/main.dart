import 'package:flutter/material.dart';
import 'package:onerc/page/authen.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: 'One RC',
      home: Authen(),
    );
  }
}
