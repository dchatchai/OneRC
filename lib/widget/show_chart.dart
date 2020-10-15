import 'dart:convert';

import 'package:charts_flutter/flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onerc/models/sales_model.dart';
import 'package:onerc/utility/my_constant.dart';
import 'package:onerc/utility/my_style.dart';

class ShowChart extends StatefulWidget {
  @override
  _ShowChartState createState() => _ShowChartState();
}

class SalesPerProduct {
  final int product;
  final int amount;

  SalesPerProduct(this.product, this.amount);
}

class _ShowChartState extends State<ShowChart> {
  List<SalesPerProduct> listSalesPerProduct = List();
  List<Series> listSeries = List();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      // BarChart
      // SalesPerProduct('Computer', 100),
      // SalesPerProduct('Monitor', 50),
      // SalesPerProduct('Network', 150),
      // SalesPerProduct('Printer', 70),
      // SalesPerProduct('Scaner', 15),
      
      // LineChart
      SalesPerProduct(0, 60),
      SalesPerProduct(10, 100),
      SalesPerProduct(20, 50),
      SalesPerProduct(30, 150),
      SalesPerProduct(40, 70),
      SalesPerProduct(50, 15),
      SalesPerProduct(60, 120),
    ];

    var series = [
      Series(seriesColor: Color(r: 3,g: 182,b: 252,),
        id: 'idChart1',
        data: listSalesPerProduct,
        domainFn: (SalesPerProduct salesPerProduct, index) =>
            salesPerProduct.product,
        measureFn: (SalesPerProduct salesPerProduct, index) =>
            salesPerProduct.amount,
      ),
      Series(seriesColor: Color(r: 252,g: 182,b: 3,),
        id: 'idChart2',
        data: data,
        domainFn: (SalesPerProduct salesPerProduct, index) =>
            salesPerProduct.product,
        measureFn: (SalesPerProduct salesPerProduct, index) =>
            salesPerProduct.amount,
      ),      
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: listSalesPerProduct.length == 0
            ? MyStyle().showProgress()
            : LineChart(
                series,
                animate: true,
              ),
      ),
    );
  }

  Future<Null> readData() async {
    String path = '${MyConstant().domain}/RCI/getAllSales.php';
    await Dio().get(path).then((value) {
      print('value => $value');
      var result = json.decode(value.data);

      for (var json in result) {
        print('json => $json');
        SalesModel salesModel = SalesModel.fromJson(json);
        int x = int.parse(salesModel.xvalue.trim());
        int y = int.parse(salesModel.yvalue.trim());

        setState(() {
          listSalesPerProduct.add(SalesPerProduct(x, y));
        });
      }
    });
  }
}
