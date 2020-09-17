import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onerc/models/user_model.dart';
import 'package:onerc/page/main_shop.dart';
import 'package:onerc/page/main_user.dart';
import 'package:onerc/page/no_internet.dart';
import 'package:onerc/page/register.dart';
import 'package:onerc/utility/my_api.dart';
import 'package:onerc/utility/my_constant.dart';
import 'package:onerc/utility/my_style.dart';
import 'package:onerc/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String user, password;
  bool status = true;

  @override
  void initState() {
    // TODO: implement initState
    // สั่งให้ทำงานก่อน build
    super.initState();
    // findLogin();
    checkInternet();
  }

  Future<Null> findLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String typeLogin = preferences.getString('Type');
    print('typeLogin = $typeLogin');

    if (typeLogin == null || typeLogin.isEmpty) {
      setState(() {
        status = false;
      });
    } else {
      switch (typeLogin) {
        case 'User':
          routeToService(MainUser());
          break;
        case 'Shop':
          routeToService(MainShop());
          break;
        default:
      }
    }
  }

  void routeToService(Widget widget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: status
          ? MyStyle().showProgress()
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MyStyle().showLogo(),
                    MyStyle().showTextH1('Royal Can'),
                    userForm(),
                    passwordForm(),
                    loginButton(),
                    registerButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Container loginButton() {
    return Container(
      width: 250,
      child: RaisedButton(
        onPressed: () {
          if (user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'กรุณากรอก User และ Password');
          } else {
            checkAuthen();
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Container registerButton() {
    return Container(
      width: 250,
      child: FlatButton(
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => Register(),
          );
          Navigator.push(context, route);
        },
        child: Text(
          'New Register',
          style: TextStyle(color: Colors.pink),
        ),
      ),
    );
  }

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

  Future<Null> checkAuthen() async {
    UserModel model = await MyAPI().getUserWhereUser(user);
    if (model == null) {
      normalDialog(context, 'ไม่มี $user ในระบบ');
    } else {
      if (password == model.password) {
        switch (model.type) {
          case 'User':
            routeTo(MainUser(), model);
            break;
          case 'Shop':
            routeTo(MainShop(), model);
            break;
          default:
        }
      } else {
        normalDialog(context, 'password ผิด');
      }
    }
  }

  Future<Null> routeTo(Widget widget, UserModel model) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', model.id);
    preferences.setString('Name', model.name);
    preferences.setString('Type', model.type);
    // ผังค่า login ของ user

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Future<Null> checkInternet() async {
    try {
      var response = await InternetAddress.lookup('www.rcithailand.com');
      if ((response.isNotEmpty) && (response[0].rawAddress.isNotEmpty)) {
        findLogin();
      }
    } catch (e) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NoInternet(),
          ),
          (route) => false);
    }
  }
}
