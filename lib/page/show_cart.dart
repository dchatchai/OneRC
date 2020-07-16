import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onerc/models/sqlite_model.dart';
import 'package:onerc/utility/my_style.dart';
import 'package:onerc/utility/normal_toast.dart';
import 'package:onerc/utility/sqlite_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SqliteModel> sqliteModels = List();
  int total = 0;

  var f = new NumberFormat("#,###", "en_US");

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
      calculateTotal();
    });
  }

  void calculateTotal() {
    total = 0;
    for (var model in sqliteModels) {
      int sumInt = int.parse(model.sumString.trim());
      setState(() {
        total = total + sumInt;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildClearButton(context),
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
                  buildOrderButton()
                ],
              ),
            ),
    );
  }

  Widget buildOrderButton() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              width: 150,
              child: RaisedButton.icon(
                  onPressed: () {
                    insertOrderToMSsql();
                  },
                  icon: Icon(Icons.fastfood),
                  label: Text('Order'))),
        ],
      );

  FloatingActionButton buildClearButton(BuildContext context) {
    return FloatingActionButton(
      child: Text('Clear'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text('ลบทั้งหมด ?'),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await SQLiteHelper().clearData().then((value) {
                          readSQLite();
                        });
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(color: Colors.green),
                      )),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      )),
                ],
              )
            ],
          ),
        );
      },
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
            // child: MyStyle().showTextH3Red('$total'),
            child: MyStyle().showTextH3Red(f.format(total)),
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
              flex: 3,
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
            Expanded(
              flex: 1,
              child: SizedBox(),
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
              flex: 3,
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
              //  child: Text(sqliteModels[index].sumString),
              child: Text(f.format(int.parse(sqliteModels[index].sumString)).toString()),              
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  confirmDelete(index);
                },
              ),
            ),
          ],
        ),
      );

  Future<Null> confirmDelete(int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการลบรายการ ${sqliteModels[index].nameProduct} ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    int idProductInt = sqliteModels[index].id;
                    await SQLiteHelper()
                        .deleteDataWhereId(idProductInt)
                        .then((value) {
                      normalToast(
                          'Delete รายการ ${sqliteModels[index].nameProduct} แล้ว');
                      readSQLite();
                    });
                  },
                  child: Text(
                    'confirm',
                    style: TextStyle(color: Colors.green),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'cancel',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          )
        ],
      ),
    );
  }

  Future<Null> insertOrderToMSsql() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idUser = preferences.getString('id');
    String nameUser = preferences.getString('Name');
    print('idUser = $idUser, nameUser = $nameUser');

    DateTime dateTime = DateTime.now();
    String dateTimeString = dateTime.toString();
    print('dateTime = $dateTimeString');

    String idShop = sqliteModels[0].idShop;
    String nameShop = sqliteModels[0].nameShop;
    print('idShop = $idShop, nameShop = $nameShop');

    List<String> idProducts = List();
    List<String> nameProducts = List();
    List<String> prices = List();
    List<String> amounts = List();
    List<String> sums = List();


    for (var model in sqliteModels) {
      String idProduct = model.idProduct;
      String nameProduct = model.nameProduct;
      String price = model.price;
      String amount = model.amountString;
      String sum = model.sumString;

      idProducts.add(idProduct);
      nameProducts.add(nameProduct);
      prices.add(price);
      amounts.add(amount);
      sums.add(sum);

    }
    String idProductString = idProducts.toString();    
    String nameProductString = nameProducts.toString();
    String priceString = prices.toString();
    String amountString = amounts.toString();
    String sumString = sums.toString();

    print('idProductString = $idProductString'); 
    print('idProductString = $nameProductString');      
    print('idProductString = $priceString');  
    print('idProductString = $amountString');  
    print('idProductString = $sumString');  





    
  }
}
