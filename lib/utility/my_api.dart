import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onerc/models/user_model.dart';
import 'package:onerc/utility/my_constant.dart';

import 'normal_dialog.dart';

class MyAPI {

  Future<Null> editValueOnMySQL(
      BuildContext context,
      String id,
      String dateTimeString,
      String address,
      String phone,
      String gender,
      String educateString) async {
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

  Future<UserModel> getUserWhereUser(String user) async {
    String url =
        '${MyConstant().domain}/RCI/getUserWhereUserUng.php?isAdd=true&User=$user';
    Response response = await Dio().get(url);
    // print('response = $response');
    if (response.toString() == 'null') {
      return null;
    } else {
      var result = json.decode(response.data);
      for (var map in result) {
        UserModel model = UserModel.fromJson(map);
        return model;
      }
    }
  }

  MyAPI();
}
