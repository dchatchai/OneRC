import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onerc/utility/my_style.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  String dateTimeString;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findCurrentTime();
  }

  Future<Null> findCurrentTime() async {
    DateTime dateTime = DateTime.now();
    setState(() {
      dateTimeString = DateFormat('dd-MM-yyyy').format(dateTime);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลร้านค้า'),
      ),
      body: Column(
        children: <Widget>[
          MyStyle().showTextH2('วันเวลาที่บันทึก : '),
          MyStyle().showTextH1(dateTimeString == null ? '' : dateTimeString)
        ],
      ),
    );
  }
}
