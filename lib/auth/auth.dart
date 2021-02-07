import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

void getNewAccessToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String url = "https://wgwebserver.herokuapp.com/user/token";

  Map body = {"token": sharedPreferences.getString('refreshToken')};

  var jsonResponse;
  var res = await http.post(url, body: body);

  if (res.statusCode == 200) {
    jsonResponse = json.decode(res.body);
    print('in auth');
    print(jsonResponse);
  }
  //Check if the old token is still valid
  //Get a new accessToken by passing refreshToken
}

// TODO

// POST http://localhost:5000/user/token
// Content-Type: application/json
// {
//     "token": ""
// }

// This will return a new access token

// authenticateUser(){
// If current token is not valid, ask for a new access token from API
// }
