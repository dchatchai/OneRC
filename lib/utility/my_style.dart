import 'package:flutter/material.dart';
import 'package:onerc/page/authen.dart';
import 'package:onerc/page/show_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyStyle {
  Color mainColor = Colors.pink;
  Color darkColor = Colors.blue.shade800;

  Widget showChart(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_shopping_cart),
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowCart(),
        );
        Navigator.push(context, route);
      },
    );
  }

  Widget mySizeBox() => SizedBox(
        height: 16,
        width: 16,
      );

  Widget menuSignOut(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.red.shade800),
          child: ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            title: Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'ออกจาก Account และไปที่ Authen',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear();

              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => Authen(),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => false);
            },
          ),
        ),
      ],
    );
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  InputDecoration myInputDecoration(String string) {
    return InputDecoration(
      labelText: string,
      border: OutlineInputBorder(),
    );
  }

  Text showTextH1(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkColor,
        ),
      );

  Widget showTextH2(String string) => Container(
        margin: EdgeInsets.only(left: 8),
        child: Text(
          string,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkColor,
          ),
        ),
      );

  Widget showTextH3(String string) => Container(
        child: Text(
          string,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: darkColor,
          ),
        ),
      );

  Widget showTextH3Red(String string) => Container(
        child: Text(
          string,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade900,
          ),
        ),
      );

  Container showLogo() {
    return Container(
      width: 150,
      child: Image.asset('images/logo.png'),
    );
  }

  MyStyle();
}
