import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onerc/utility/my_constant.dart';
import 'package:onerc/utility/my_style.dart';
import 'package:onerc/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  String dateTimeString, gender, educateString, address, phone, id;
  List<String> educate = [
    'ต่ำกว่า ป.6',
    'มัธยมต้น',
    'มัธยมปลาย',
    'ป.ตรี',
    'ป.โท',
    'ป.เอก'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findId();
    findCurrentTime();
  }

  Future<Null> findId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id');
  }

  Future<Null> findCurrentTime() async {
    DateTime dateTime = DateTime.now();
    setState(() {
      dateTimeString = DateFormat('dd-MM-yyyy').format(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (address == null ||
              address.isEmpty ||
              phone == null ||
              phone.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
          } else if (gender == null) {
            normalDialog(context, 'กรุณาเลือก gender');
          } else if (educateString == null) {
            normalDialog(context, 'กรุณาเลือก Educate');
          } else {
            editValueOnMySQL();
          }
        },
        child: Icon(Icons.cloud_upload),
      ),
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลร้านค้า'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            titleDate(),
            showDate(),
            addressForm(),
            phoneForm(),
            genderGroup(),
            educateGroup(),
          ],
        ),
      ),
    );
  }

  Container educateGroup() => Container(
        child: DropdownButton<String>(
          value: educateString,
          items: educate
              .map(
                (e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ),
              )
              .toList(),
          hint: Text('Please choose education'),
          onChanged: (value) {
            setState(() {
              educateString = value;
            });
          },
        ),
      );

  Container genderGroup() => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            maleRadio(),
            femaleRadio(),
          ],
        ),
      );

  Row maleRadio() {
    return Row(
      children: <Widget>[
        Radio(
          value: 'Male',
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              gender = value;
            });
          },
        ),
        Text('ผู้ชาย'),
      ],
    );
  }

  Row femaleRadio() {
    return Row(
      children: <Widget>[
        Radio(
          value: 'Female',
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              gender = value;
            });
          },
        ),
        Text('ผู้หญิง'),
      ],
    );
  }

  Row showDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MyStyle().showTextH1(dateTimeString == null ? '' : dateTimeString),
      ],
    );
  }

  Widget titleDate() => MyStyle().showTextH2('วันเวลาที่บันทึก : ');

  Widget addressForm() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => address = value.trim(),
          decoration: MyStyle().myInputDecoration('ที่อยู่ : '),
        ),
      );

  Widget phoneForm() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => phone = value.trim(),
          keyboardType: TextInputType.phone,
          decoration: MyStyle().myInputDecoration('เบอร์โทรศัพท์ : '),
        ),
      );

  Future<Null> editValueOnMySQL() async {
    String url =
        '${MyConstant().domain}/RCI/editUserWhereIdUng.php?id=$id&isAdd=true&CreateDate=$dateTimeString&Address=$address&Phone=$phone&Gendel=$gender&Education=$educateString';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'Please try again');
      }
    });
  }
}
