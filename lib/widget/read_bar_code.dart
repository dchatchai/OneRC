import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onerc/utility/my_style.dart';
import 'package:onerc/utility/normal_dialog.dart';
import 'package:onerc/widget/detail_barcode.dart';

class ReadBarCode extends StatefulWidget {
  @override
  _ReadBarCodeState createState() => _ReadBarCodeState();
}

class _ReadBarCodeState extends State<ReadBarCode> {
  String barcodeString, itemCode, weightCode, priceCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Barcode'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildBarCodeButton(),
          itemCode == null ? SizedBox() : buildTextResult(),
        ],
      ),
    );
  }

  Widget buildTextResult() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              child: ListTile(
                onTap: () =>  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailBarcode(
                      barcodeString: itemCode,
                    ),
                  ),
                ),
                title: MyStyle().showTextH2('ItemCode = $itemCode'),
                trailing: Icon(
                  Icons.forward,
                  size: 36,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          MyStyle().showTextH2('Weight = $weightCode Kg.'),
          MyStyle().showTextH2('Price = $priceCode บาท'),
        ],
      );

  Row buildBarCodeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            print('Click Barcode');
            barCodeReader();
          },
          child: Card(
            child: Container(
              width: 150,
              child: Image.asset('images/barcode.png'),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> barCodeReader() async {
    try {
      var result = await BarcodeScanner.scan();
      barcodeString = result.rawContent;
      print('barcodeString ==>> $barcodeString');

      if (barcodeString.length == 20) {
        decodeBarcode();
      } else if (barcodeString.length == 22) {
      } else {
        normalDialog(context, 'Barcode ไม่ถูกต้อง');
      }
    } catch (e) {}
  }

  void decodeBarcode() {
    setState(() {
      itemCode = barcodeString.substring(0, 8);
      // print('itemCode = $itemCode');

      weightCode = barcodeString.substring(8, 14);
      weightCode =
          '${weightCode.substring(0, 3)}.${weightCode.substring(3, 6)}';
      double weightDouble = double.parse(weightCode);
      var weightFormat = NumberFormat('##0.000', 'en_US');
      weightCode = weightFormat.format(weightDouble);
      // print('weightcode = $weightCode');
      // print('weightDouble = $weightDouble');
      priceCode = barcodeString.substring(14, 20);
      priceCode = '${priceCode.substring(0, 4)}.${priceCode.substring(4, 6)}';
      double priceDouble = double.parse(priceCode);
      var priceFormat = NumberFormat('#,##0.00', 'en_US');
      priceCode = priceFormat.format(priceDouble);
      // print('priceCode = $priceCode');
    });
  }
}
