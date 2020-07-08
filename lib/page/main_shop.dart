import 'package:flutter/material.dart';
import 'package:onerc/utility/my_style.dart';
import 'package:onerc/widget/show_info_shop.dart';
import 'package:onerc/widget/show_my_order_shop.dart';
import 'package:onerc/widget/show_my_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {

  Widget currentWidget = ShowMyOrderShop();
  String idShop, nameShop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findShop();
  }

  Future<Null> findShop()async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idShop = preferences.getString('id');
      nameShop = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer(),
      appBar: AppBar(
        title: Text(nameShop == null ? 'Welcome Shop' : 'ร้าน $nameShop' ),
      ),
      body: currentWidget,
    );
  }

  Drawer showDrawer() {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              UserAccountsDrawerHeader(accountName: null, accountEmail: null),
              menuMyOrder(),
              menuMyProduct(),
              menuMyInformation()
            ],
          ),MyStyle().menuSignOut(context),
        ],
      ),
    );
  }

  ListTile menuMyOrder() => ListTile(
        leading: Icon(Icons.looks_one),
        title: Text('Show My Orders'),
        subtitle: Text('ดูรายการสั่งของ'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = ShowMyOrderShop();
          });
        },
      );

  ListTile menuMyProduct() => ListTile(
        leading: Icon(Icons.looks_two),
        title: Text('Show My Products'),
        subtitle: Text('ดูรายการสินค้า'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = ShowMyProduct();
          });
        },
      );

  ListTile menuMyInformation() => ListTile(
        leading: Icon(Icons.looks_3),
        title: Text('Show My Information'),
        subtitle: Text('ดูข้อมูลร้านค้า'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = ShowInfoShop(idShop: idShop,);
          });
        },
      );
}
