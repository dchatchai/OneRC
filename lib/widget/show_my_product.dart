import 'package:flutter/material.dart';
import 'package:onerc/page/add_product_shop.dart';

class ShowMyProduct extends StatefulWidget {
  @override
  _ShowMyProductState createState() => _ShowMyProductState();
}

class _ShowMyProductState extends State<ShowMyProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => AddProductShop(),
          );
          Navigator.push(context, route).then((value) => null);
        },
        child: Icon(Icons.restaurant_menu),
      ),
      body: Text('This is My Products123'),
    );
  }
}
