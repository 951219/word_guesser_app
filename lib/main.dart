import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_guesser_app/entry_page.dart';
import 'package:word_guesser_app/login_page.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO mode it to another file
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var loggedIn;
  if (sharedPreferences.containsKey("refreshToken")) {
    String url = "https://wgwebserver.herokuapp.com/user/token";
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

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black),
      home: loggedIn ? EntryPage() : LoginPage(),
    ),
  );
}
