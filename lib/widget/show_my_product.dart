import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onerc/models/product_model.dart';
import 'package:onerc/page/add_product_shop.dart';
import 'package:onerc/utility/my_constant.dart';
import 'package:onerc/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMyProduct extends StatefulWidget {
  @override
  _ShowMyProductState createState() => _ShowMyProductState();
}

class _ShowMyProductState extends State<ShowMyProduct> {
  String idShop;
  bool waitStatus = true; // true = Load data
  bool dataStatus = true; // true = no Menu
  List<ProductModel> productModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    findShopAndMenu();
  }

  Future<Null> findShopAndMenu() async {
    if (productModels.length != 0) {
      productModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    idShop = preferences.getString('id');

    String url =
        '${MyConstant().domain}/RCI/getProductWhereIdShopUng.php?isAdd=true&IdShop=$idShop';

    await Dio().get(url).then((value) {
      setState(() {
        waitStatus = false;
      });

      if (value.toString() != 'null') {
        var result = json.decode(value.data);

        for (var map in result) {
          ProductModel productModel = ProductModel.fromJson(map);

          setState(() {
            dataStatus = false;
            productModels.add(productModel);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => AddProductShop(),
          );
          Navigator.push(context, route).then((value) => findShopAndMenu());
        },
        child: Icon(Icons.restaurant_menu),
      ),
      body: waitStatus
          ? MyStyle().showProgress()
          : dataStatus
              ? Center(
                  child: MyStyle()
                      .showTextH1('ไม่มี่ข้อมูลสินค้า กรุณาเพิ่มสินค้า'))
              : productModels.length == 0
                  ? MyStyle().showProgress()
                  : ListView.builder(
                      itemCount: productModels.length,
                      itemBuilder: (context, index) => Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.4,
                            child: Image.network(
                              '${MyConstant().domain}${productModels[index].pathImage}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.5,
                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    MyStyle().showTextH2(productModels[index].name),
                                  ],
                                ),
                                MyStyle().showTextH2('ราคา ${productModels[index].price} บาท'),
                                MyStyle().showTextH2(productModels[index].detail),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
