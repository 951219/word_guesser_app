import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

logIn() {}

Future<void> logOut(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String url = "${constants.DOMAIN}/user/logout";
  Map body = {"token": sharedPreferences.getString('refreshToken')};

  var jsonResponse;
  var res = await http.post(url, body: body);

  if (res.statusCode == 204) {
    sharedPreferences.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        ),
        (Route<dynamic> route) => false);
    print('User logged out');
  } else {
    jsonResponse = json.decode(res.body);
    print("Could not log out the user: \n" + jsonResponse['message']);
  }
}

validateTokenAndHttpGet(String url) {
  // navigate to url, if token expired, fetch a new one.
}
