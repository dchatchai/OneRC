import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onerc/models/user_model.dart';
import 'package:onerc/utility/my_constant.dart';
import 'package:onerc/utility/my_style.dart';

class EditInfoShop extends StatefulWidget {
  final UserModel userModel;

  EditInfoShop({Key key, this.userModel}) : super(key: key);

  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel userModel;
  String dateTimeString, gender, educateString, address, phone, id;
  List<String> educate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    //dateTimeString = userModel.createDate;
    gender = userModel.gendel;
    educateString = userModel.education;
    address = userModel.address;
    phone = userModel.phone;
    id = userModel.id;
    findCurrentTime();

    educate = MyConstant().educate;
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
      appBar: AppBar(
        title: Text('Edit Information'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            showDate(),
            addressForm(),
            phoneForm(),
            genderGroup(),
            educationDropdown(),
          ],
        ),
      ),
    );
  }

  Container educationDropdown() => Container(
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
        Text('ชาย'),
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

  Widget addressForm() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextFormField(
          initialValue: address,
          decoration: MyStyle().myInputDecoration('Address : '),
        ),
      );

  Widget phoneForm() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextFormField(
          initialValue: phone,
          decoration: MyStyle().myInputDecoration('Phone : '),
        ),
      );

  Widget showDate() => MyStyle().showTextH2('DateTime = $dateTimeString');
}
