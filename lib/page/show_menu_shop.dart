import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onerc/models/product_model.dart';
import 'package:onerc/models/sqlite_model.dart';
import 'package:onerc/models/user_model.dart';
import 'package:onerc/utility/my_constant.dart';
import 'package:onerc/utility/my_style.dart';
import 'package:onerc/utility/normal_dialog.dart';
import 'package:onerc/utility/normal_toast.dart';
import 'package:onerc/utility/sqlite_helper.dart';

class ShowMenuShop extends StatefulWidget {
  final UserModel userModel;

  ShowMenuShop({Key key, this.userModel}) : super(key: key);

  @override
  _ShowMenuShopState createState() => _ShowMenuShopState();
}

class _ShowMenuShopState extends State<ShowMenuShop> {
  UserModel userModel;
  bool status = true; // true : response = null
  Widget currentWidget = Center(
    child: Text('ยังไม่มีเมนูอาหาร'),
  );
  List<ProductModel> productModels = List();
  int amount = 1;

  @override
  void initState() {
    // TODO: implement initState

    userModel = widget.userModel;
    readMenuShop();
  }

  Future<Null> readMenuShop() async {
    String idShop = userModel.id;
    String url =
        '${MyConstant().domain}/RCI/getProductWhereIdShopUng.php?isAdd=true&IdShop=$idShop';

    await Dio().get(url).then((value) {
      setState(() {
        status = false;
      });

      if (value.toString() != 'null') {
        var result = json.decode(value.data);

        for (var map in result) {
          ProductModel model = ProductModel.fromJson(map);

          setState(() {
            productModels.add(model);
            currentWidget = showListMenu();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: <Widget>[MyStyle().showChart(context)],
          title: Text(userModel.name),
        ),
        body: status ? MyStyle().showProgress() : currentWidget);
  }

  Widget showListMenu() {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          showConfirm(index);
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(
                          '${MyConstant().domain}${productModels[index].pathImage}'),
                      fit: BoxFit.cover)),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5 - 20,
              height: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(productModels[index].name),
                  Text('ราคา ${productModels[index].price} บาท'),
                  Text(productModels[index].detail),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> showConfirm(int index) async {
    amount = 1;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          title: Text(productModels[index].name),
          children: <Widget>[
            Container(
              width: 150,
              height: 120,
              child: Image.network(
                  '${MyConstant().domain}${productModels[index].pathImage}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('ราคา ${productModels[index].price} บาท'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () {
                    setState(() {
                      amount++;
                    });
                    // print('amount = $amount');
                    // insertOrderToSQLite(index);
                  },
                ),
                Text('$amount'),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    if (amount == 1) {
                      amount = 1;
                    } else {
                      setState(() {
                        amount--;
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      insertOrderToSQLite(index);
                    },
                    child: Text('Order'),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Null> insertOrderToSQLite(int index) async {
    String idShop = productModels[index].idShop;
    String nameShop = productModels[index].nameShop;
    String idProduct = productModels[index].id;
    String nameProduct = productModels[index].name;
    String price = productModels[index].price;
    String amountString = amount.toString();
    int sum = int.parse(price.trim()) * amount;
    String sumString = sum.toString();
    // print('idShop = $idShop, nameShop = $nameShop, idProduct = $idProduct, nameProduct = $nameProduct');
    // print('price = $price, sum = $sumString');
    Map<String, dynamic> map = Map();
    map['idShop'] = idShop;
    map['nameShop'] = nameShop;
    map['idProduct'] = idProduct;
    map['nameProduct'] = nameProduct;
    map['price'] = price;
    map['amountString'] = amountString;
    map['sumString'] = sumString;

    SqliteModel sqliteModel = SqliteModel.fromJson(map);

    List<SqliteModel> resultFormSQLite =
        await SQLiteHelper().readDataFromSQLite();
    print('resultFromSQLite length = ${resultFormSQLite.length}');

    if (resultFormSQLite.length == 0) {
      await SQLiteHelper().insertDataToSQLite(sqliteModel).then((value) {
        normalToast('Add Order Success');
      });
    } else {
      String currentIdShop = resultFormSQLite[0].idShop;
      // print('currentIdShop = $currentIdShop');
      if (idShop == currentIdShop) {
        await SQLiteHelper().insertDataToSQLite(sqliteModel).then((value) {
          normalToast('Add Order Success');
        });
      } else {
        normalDialog(context, 'กรุณาซื้อของจากร้าน ${resultFormSQLite[0].nameShop}');
      }
    }
  }
}
