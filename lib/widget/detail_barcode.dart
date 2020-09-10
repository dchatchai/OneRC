import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DetailBarcode extends StatefulWidget {
  final String barcodeString;
  DetailBarcode({Key key, this.barcodeString}) : super(key: key);

  @override
  _DetailBarcodeState createState() => _DetailBarcodeState();
}

class _DetailBarcodeState extends State<DetailBarcode> {
  String barcode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    barcode = widget.barcodeString;
    if (barcode == null) {
      barcode = '';
    } else {
      readFirebase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail : $barcode'),
      ),
    );
  }

  Future<Null> readFirebase() async {
    await Firebase.initializeApp().then((value) {
      print('Success Initialize');
    });
  }
}
