import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onerc/models/user_model.dart';
import 'package:onerc/page/show_cart.dart';
import 'package:onerc/page/show_menu_shop.dart';
import 'package:onerc/utility/my_constant.dart';
import 'package:onerc/utility/my_style.dart';
import 'package:onerc/widget/download_file.dart';
import 'package:onerc/widget/generate_qrcode.dart';
import 'package:onerc/widget/read_bar_code.dart';
import 'package:onerc/widget/show_chart.dart';
import 'package:onerc/widget/show_location.dart';
// import 'package:onerc/widget/show_my_order_shop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  List<UserModel> userModels = List();
  List<Widget> widgets = List();
  String nameLogin;
  // Widget currentWidget = ShowChart();
  //Widget currentWidget = ShowLocation();
  Widget currentWidget = DownloadFile();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readShop();
    findNameLogin();
  }

  Future<Null> findNameLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    nameLogin = preferences.getString('Name');
  }

  Future<Null> readShop() async {
    String url =
        '${MyConstant().domain}/RCI/getUserWhereType.php?isAdd=true&Type=Shop';

    Response response = await Dio().get(url);
    // print('res = $response');
    var result = json.decode(response.data);
    // print('result = $result');
    int index = 0;
    for (var map in result) {
      UserModel model = UserModel.fromJson(map);
      if (!(model.createDate.isEmpty)) {
        // print('nameShop ==> ${model.name}');
        setState(() {
          userModels.add(model);
          widgets.add(createWidget(model.name, index));
        });
        index++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var listTile = ListTile();
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                showHead(),
                buildShowChart(),
                buildShowLocation(),
                buildShowDownloadFile(),
                buildShowGenQRcode(),
                buildCart(),
                buildReadBarCode(),
              ],
            ),
            MyStyle().menuSignOut(context),
          ],
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[MyStyle().showChart(context)],
        title: Text('Welcome User'),
      ),
      body: currentWidget,
      // body: userModels.length == 0 ? MyStyle().showProgress() : buildShop(),
    );
  }

  ListTile buildShowChart() => ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = ShowChart();
          });
        },
        leading: Icon(
          Icons.graphic_eq,
          size: 36,
          color: Colors.blue,
        ),
        title: Text('แสดงกราฟ'),
        subtitle: Text('Demo Show Chart'),
      );

  ListTile buildShowLocation() => ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = ShowLocation();
          });
        },
        leading: Icon(
          Icons.map,
          size: 36,
          color: Colors.brown,
        ),
        title: Text('แสดงพิกัด'),
        subtitle: Text('Show all user location.'),
      );

  ListTile buildShowDownloadFile() => ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = DownloadFile();
          });
        },
        leading: Icon(
          Icons.cloud_download,
          size: 36,
          color: Colors.orange,
        ),
        title: Text('Download File'),
        subtitle: Text('Show all File'),
      );

  ListTile buildShowGenQRcode() => ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = GenerateQRcode();
          });
        },
        leading: Icon(
          Icons.scanner,
          size: 36,
          color: Colors.yellow,
        ),
        title: Text('Gen QRcode'),
        subtitle: Text('สร้าง QRcode'),
      );

  ListTile buildCart() => ListTile(
        onTap: () {
          Navigator.pop(context);
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ShowCart(),
          );
          Navigator.push(context, route);
        },
        leading: Icon(
          Icons.add_shopping_cart,
          size: 36,
          color: Colors.pink,
        ),
        title: Text('ตะกร้าของฉัน'),
        subtitle: Text('แสดงสินค้า'),
      );

  ListTile buildReadBarCode() => ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadBarCode(),
              ));
        },
        leading: Icon(
          Icons.android,
          size: 36,
          color: Colors.green,
        ),
        title: Text('Read Barcode'),
        subtitle: Text('อ่าน Barcode'),
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/wall.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        currentAccountPicture: Image.asset('images/logo.png'),
        accountName: Text(nameLogin == null ? 'Name ?' : nameLogin),
        accountEmail: Text('Login'));
  }

  Widget buildShop() => GridView.extent(
        maxCrossAxisExtent: 160,
        children: widgets,
      );

  Widget createWidget(String name, int index) {
    return GestureDetector(
      onTap: () {
        // print('You Click $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowMenuShop(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              child: Image.asset('images/shop.png'),
            ),
            Text(name),
          ],
        ),
      ),
    );
  }
}
