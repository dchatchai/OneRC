import 'package:flutter/material.dart';

class ShowInfoShop extends StatefulWidget {
  final String idShop;
  ShowInfoShop({Key key, this.idShop});

  @override
  _ShowInfoShopState createState() => _ShowInfoShopState();
}

class _ShowInfoShopState extends State<ShowInfoShop> {
  String idShop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    idShop = widget.idShop;
  }

  @override
  Widget build(BuildContext context) {
    return Text('This is My Information of id = $idShop');
  }
}
