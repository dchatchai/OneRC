import 'package:flutter/material.dart';
import 'package:onerc/utility/my_style.dart';
import 'package:onerc/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<String> types = ['User', 'Shop']; // array
  String type, name, user, password;

  Widget userForm() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: MyStyle().myInputDecoration('User :'),
        ),
      );

  Widget passwordForm() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          decoration: MyStyle().myInputDecoration('Password :'),
        ),
      );

  Widget nameForm() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: MyStyle().myInputDecoration('Name :'),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (name == null ||
              name.isEmpty ||
              user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'Please Fill Every Blank');
          } else if (type == null) {
            normalDialog(context, 'โปรดเลือกชนิดของสมาชิก');
          } else {}
        },
        child: Icon(Icons.cloud_upload),
      ),
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MyStyle().showLogo(),
              nameForm(),
              dropDownType(),
              userForm(),
              passwordForm(),
            ],
          ),
        ),
      ),
    );
  }

  Container dropDownType() => Container(
        child: DropdownButton(
          items: types
              .map(
                (e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ),
              )
              .toList(),
          hint: Text('Choose Type'),
          value: type,
          onChanged: (value) {
            setState(() {
              type = value;
            });
          },
        ),
      );
}
