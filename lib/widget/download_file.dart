import 'package:flutter/material.dart';

class DownloadFile extends StatefulWidget {
  @override
  _DownloadFileState createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RaisedButton(
        onPressed: null,
        child: Text('Download Files'),
      ),
    );
  }
}
