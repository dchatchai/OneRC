import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onerc/models/user_model.dart';
import 'package:onerc/page/add_info_shop.dart';
import 'package:onerc/page/edit_info_shop.dart';
import 'package:onerc/utility/my_constant.dart';
import 'package:onerc/utility/my_style.dart';

class ShowInfoShop extends StatefulWidget {
  final String idShop;
  ShowInfoShop({Key key, this.idShop});

  @override
  _ShowInfoShopState createState() => _ShowInfoShopState();
}

class _ShowInfoShopState extends State<ShowInfoShop> {
  String idShop;
  bool status = true;
  bool status2 = true;
  UserModel userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    idShop = widget.idShop;
    readInfo();
  }

  Future<Null> readInfo() async {
    String url =
        '${MyConstant().domain}/RCI/getUserWhereIdUng.php?isAdd=true&id=$idShop';
    Response response = await Dio().get(url);
    setState(() {
      status2 = false;
    });
    var result = json.decode(response.data);
    for (var map in result) {
      userModel = UserModel.fromJson(map);
      String dateTime = userModel.createDate;
      if (!(dateTime == null || dateTime.isEmpty)) {
        setState(() {
          status = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: status ? addButton(context) : editButton(context),
      body: status2
          ? MyStyle().showProgress()
          : status
              ? Center(
                  child: MyStyle().showTextH1('ยังไม่มีข้อมูลร้านค้า'),
                )
              : showContent(),
    );
  }

  FloatingActionButton addButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => AddInfoShop(),
        );
        Navigator.push(context, route).then((value) => readInfo());
      },
      child: Icon(Icons.add),
    );
  }

  FloatingActionButton editButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => EditInfoShop(userModel: userModel,),
        );
        Navigator.push(context, route).then((value) => readInfo());
      },
      child: Icon(Icons.edit),
    );
  }

  Widget showContent() => Column(
        children: <Widget>[
          MyStyle().showTextH1('ข้อมูลร้าน ${userModel.name}'),
          MyStyle().showTextH2('บันทึกวันที่ ${userModel.createDate}'),
          showAddress(),
          showGendel(),
          showEducate(),
          showPhone(),
        ],
      );

  ListTile showAddress() {
    return ListTile(
      leading: Icon(
        Icons.home,
        size: 36,
        color: Colors.purple,
      ),
      title: MyStyle().showTextH2(userModel.address),
    );
  }

  ListTile showGendel() {
    return ListTile(
      leading: Icon(
        Icons.account_box,
        size: 36,
        color: Colors.orange,
      ),
      title: MyStyle().showTextH2(userModel.gendel),
    );
  }

  ListTile showEducate() {
    return ListTile(
      leading: Icon(
        Icons.label_important,
        size: 36,
        color: Colors.orange,
      ),
      title: MyStyle().showTextH2(userModel.education),
    );
  }

  ListTile showPhone() {
    return ListTile(
      leading: Icon(
        Icons.phone,
        size: 36,
        color: Colors.blue,
      ),
      title: MyStyle().showTextH2(userModel.phone),
    );
  }
}
