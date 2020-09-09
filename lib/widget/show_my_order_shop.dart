import 'package:flutter/material.dart';

class ShowMyOrderShop extends StatefulWidget {
  @override
  _ShowMyOrderShopState createState() => _ShowMyOrderShopState();
}

class _ShowMyOrderShopState extends State<ShowMyOrderShop> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Text('This is My Order 12345');
  }

  Future<Null> readData() async{
    
  }
}
