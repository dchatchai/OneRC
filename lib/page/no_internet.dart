import 'dart:io';

import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No Internet Connection'),
            RaisedButton.icon(
                onPressed: () => exit(0),
                icon: Icon(Icons.exit_to_app),
                label: Text('Exit'))
          ],
        ),
      ),
    );
  }
}
