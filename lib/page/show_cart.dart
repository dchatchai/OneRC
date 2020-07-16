import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:onerc/models/sqlite_model.dart';
import 'package:onerc/utility/my_style.dart';
import 'package:onerc/utility/sqlite_helper.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SqliteModel> sqliteModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    List<SqliteModel> object = await SQLiteHelper().readDataFromSQLite();
    setState(() {
      sqliteModels = object;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าของฉัน'),
      ),
      body: sqliteModels.length == 0
          ? Center(
              child: Text('ว่าง'),
            )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                children: <Widget>[
                  buildNameShop(),
                  buildHeadTitle(),
                  buildListView(),
                  Divider(
                    thickness: 2,
                    color: Colors.blueGrey.shade100,
                  ),
                  buildTotal(),
                ],
              ),
          ),
    );
  }

  Widget buildTotal() => Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('ผลรวม : '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTextH3Red('xXx'),
          ),
        ],
      );

  Widget buildHeadTitle() => Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: MyStyle().showTextH3('รายการอาหาร'),
            ),
            Expanded(
              flex: 1,
              child: MyStyle().showTextH3('ราคา'),
            ),
            Expanded(
              flex: 1,
              child: MyStyle().showTextH3('จำนวน'),
            ),
            Expanded(
              flex: 1,
              child: MyStyle().showTextH3('รวม'),
            ),
          ],
        ),
      );

  Row buildNameShop() {
    return Row(
      children: <Widget>[
        MyStyle().showTextH1(sqliteModels[0].nameShop),
      ],
    );
  }

  ListView buildListView() => ListView.builder(
        shrinkWrap: true, // ขยาย listview
        physics: ScrollPhysics(),
        itemCount: sqliteModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Text(sqliteModels[index].nameProduct),
            ),
            Expanded(
              flex: 1,
              child: Text(sqliteModels[index].price),
            ),
            Expanded(
              flex: 1,
              child: Text(sqliteModels[index].amountString),
            ),
            Expanded(
              flex: 1,
              child: Text(sqliteModels[index].sumString),
            ),
          ],
        ),
      );
}
