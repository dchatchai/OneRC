import 'package:flutter/material.dart';
import 'package:onerc/page/add_info_shop.dart';

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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => AddInfoShop(),
          );
          Navigator.push(context, route).then((value) => null);
        },
        child: Icon(Icons.add),
      ),
      body: Text('This is My Information of id = $idShop'),
    );
  }
}
