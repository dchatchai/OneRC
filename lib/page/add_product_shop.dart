import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onerc/utility/my_constant.dart';
import 'package:onerc/utility/my_style.dart';
import 'package:onerc/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductShop extends StatefulWidget {
  @override
  _AddProductShopState createState() => _AddProductShopState();
}

class _AddProductShopState extends State<AddProductShop> {
  File file;
  String pathImage, name, price, detail, nameShop, idShop, code;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findShop();
  }

  Future<Null> findShop() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idShop = preferences.getString('id');
    nameShop = preferences.getString('Name');
    print('idshop = $idShop, nameshop = $nameShop');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (file == null) {
            normalDialog(context, 'Please choose image');
          } else if (name == null ||
              name.isEmpty ||
              price == null ||
              price.isEmpty ||
              detail == null ||
              detail.isEmpty) {
            normalDialog(context, 'Please fill');
          } else {
            uploadAndInsertProduct();
          }
        },
        child: Icon(Icons.cloud_upload),
      ),
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Center(
        child: SingleChildScrollView(
          //wrap with widget
          child: Column(
            children: <Widget>[
              imageGroup(),
              nameForm(),
              priceForm(),
              detailForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget nameForm() => Container(
        width: 250,
        margin: EdgeInsets.only(top: 16),
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: MyStyle().myInputDecoration('Name Product : '),
        ),
      );

  Widget priceForm() => Container(
        width: 250,
        margin: EdgeInsets.only(top: 16),
        child: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) => price = value.trim(),
          decoration: MyStyle().myInputDecoration('Price : '),
        ),
      );

  Widget detailForm() => Container(
        width: 250,
        margin: EdgeInsets.only(top: 16),
        child: TextField(
          onChanged: (value) => detail = value.trim(),
          decoration: MyStyle().myInputDecoration('Detail Product : '),
        ),
      );

  Future<Null> chooseSource(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget imageGroup() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseSource(ImageSource.camera),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child:
                file == null ? Image.asset('images/pic.png') : Image.file(file),
            width: 200,
            height: 200,
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseSource(ImageSource.gallery),
          )
        ],
      );

  Future<Null> uploadAndInsertProduct() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'idShop${idShop}product$i.jpg';
    print('nameFile = $nameFile');
    code = 'idShop${idShop}code$i';
    print('code = $code');

    try {
      String urlUpload = '${MyConstant().domain}/RCI/saveFileUng.php';
      Map<String, dynamic> map = Map();

      map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);
      await Dio().post(urlUpload, data: formData).then((value) async {
        pathImage = '/RCI/Product/$nameFile';
        print(
            'upload success => pathImage = ${MyConstant().domain}$pathImage ');

        String urlInsert =
            '${MyConstant().domain}/RCI/addProductUng.php?isAdd=true&IdShop=$idShop&NameShop=$nameShop&Name=$name&Price=$price&Detail=$detail&PathImage=$pathImage&Code=$code';
        await Dio().get(urlInsert).then((value) {
          if (value.toString() == 'true') {
            Navigator.pop(context);
            
          } else {
            normalDialog(context, 'Please try again');
          }
        });
      });
    } catch (e) {}
  }
}
