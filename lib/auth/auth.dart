import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart' as constants;

import 'package:shared_preferences/shared_preferences.dart';

// checks if refreshToken is valid, it it is then it will return a new accessToken and saves it in sharedprefs
Future<bool> isLoggedIn() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var loggedIn;
  if (sharedPreferences.containsKey("refreshToken")) {
    String url = "${constants.DOMAIN}/user/token";
    Map body = {
      "refreshToken": sharedPreferences.getString('refreshToken'),
      "accessToken": sharedPreferences.getString('accessToken')
    };
    var response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      sharedPreferences.setString('accessToken', jsonResponse['accessToken']);
      loggedIn = true;
    } else {
      print("statuscode: ${response.statusCode}");
      sharedPreferences.clear();
      loggedIn = false;
    }
  } else {
    print("No refreshToken in sharedprefs");
    loggedIn = false;
  }
  return loggedIn;
}
