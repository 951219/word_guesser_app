import 'dart:convert';

import 'package:http/http.dart' as http;
import './constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

logIn() {}

Future<bool> logOut() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String url = "${constants.DOMAIN}/user/logout";
  Map body = {"token": sharedPreferences.getString('refreshToken')};

  var jsonResponse;
  var res = await http.post(url, body: body);

  if (res.statusCode == 204) {
    return true;
  } else {
    jsonResponse = json.decode(res.body);
    print(jsonResponse['message']);
    return false;
  }
// Delete the refreshtoken from db and clear sharedprefs
}

validateTokenAndHttpGet(String url) {
  // navigate to url, if token expired, fetch a new one.
}
