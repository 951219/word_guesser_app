import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:word_guesser_app/tab_frame.dart';
import '../constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

import '../login_page.dart';

Future<void> singIn(
    String username, String password, BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String url = "${constants.DOMAIN}/user/login";

  Map body = {"username": username.toLowerCase(), "password": password};

  var jsonResponse;
  var res = await http.post(url, body: body);

  if (res.statusCode == 200) {
    jsonResponse = json.decode(res.body);

    print("Response status: ${res.statusCode}");

    if (jsonResponse != null) {
      sharedPreferences.setString("refreshToken", jsonResponse['refreshToken']);
      sharedPreferences.setString("accessToken", jsonResponse['accessToken']);
      sharedPreferences.setBool('loggedIn', true);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => EntryPage(),
          ),
          (Route<dynamic> route) => false);
    } else {
      print("Response status: ${res.body}");
    }
  } else {
    print("Error: Response status: ${res.statusCode}");
  }
}

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

// checks if refreshToken is valid, it it is then it will return a new accessToken and saves it in sharedprefs
Future<bool> syncIsLoggedIn() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var loggedIn;
  if (sharedPreferences.containsKey("refreshToken") &&
      sharedPreferences.containsKey("accessToken")) {
    String url = "${constants.DOMAIN}/user/token";
    Map body = {
      "refreshToken": sharedPreferences.getString('refreshToken'),
      "accessToken": sharedPreferences.getString('accessToken')
    };
    var response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      print('Got a new token from the API');
      var jsonResponse = json.decode(response.body);
      await sharedPreferences.setString(
          "accessToken", jsonResponse['accessToken']);
      loggedIn = true;
    } else if (response.statusCode == 403) {
      print(
          "Statuscode: ${response.statusCode} \n Forbidden: Your token is invalid");
    } else {
      print("Statuscode: ${response.statusCode}");
      //TODO await sharedPreferences.clear();
      loggedIn = false;
    }
  } else {
    print("No refreshToken/accessToken in sharedprefs");
    // logOut();
    loggedIn = false;
  }
  return loggedIn;
}

fetchUser(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.containsKey("refreshToken") &&
      sharedPreferences.containsKey("accessToken")) {
    print('sharedPreferences contains both');
    var url = "${constants.DOMAIN}/user/getinfo";
    var res = await http.get(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${sharedPreferences.getString('accessToken')}"
    });
    if (res.statusCode == 200) {
      print("Response status: ${res.statusCode} - Got the user");
      return json.decode(res.body);
    } else if (res.statusCode == 403) {
      print(
          "Response status: ${res.statusCode} - Sending a request to get a new access token");
      await syncIsLoggedIn();
      return fetchUser(context);
    } else {
      print("Response status: ${res.statusCode}");
    }
  } else {
    print(
        'sharedPreferences does not contain both: \n refresh: ${sharedPreferences.getString("refreshToken")} access: ${sharedPreferences.getString("accessToken")} - logging out');
    sharedPreferences.clear();
    logOut(context);
  }
}
