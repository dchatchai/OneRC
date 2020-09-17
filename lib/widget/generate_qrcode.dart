import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRcode extends StatefulWidget {
  @override
  _GenerateQRcodeState createState() => _GenerateQRcodeState();
}

class _GenerateQRcodeState extends State<GenerateQRcode> {
  File file;
  GlobalKey globalKey = GlobalKey();
  String code = '01000015000085002201';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            buildImage(),
            buildBarcodeWidget(),
          ],
        ),
      ),
    );
  }

  Widget buildBarcodeWidget() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: BarcodeWidget(height: 90,
        data: code,
        barcode: Barcode.code128(),
      ),
    );
  }

  Widget buildImage() {
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        width: 200,
        child: QrImage(data: code),
      ),
    );
  }

  Widget buildRaisedButton() {
    return RaisedButton(
      onPressed: () => generateThread(),
      child: Text('Gen QR'),
    );
  }

  Future<Null> generateThread() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var imageQR = await boundary.toImage();
      ByteData byteData = await imageQR.toByteData(format: ImageByteFormat.png);
      Uint8List uint8list = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();

      var myfile = await File('${tempDir.path}/qrimage.png').create();
      await myfile.writeAsBytes(uint8list).then((value) {
        print('success QR');
      });
    } catch (e) {
      print('error gen qr =>${e.toString()}');
    }
  }
}
