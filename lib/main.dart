import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_guesser_app/entry_page.dart';
import 'package:word_guesser_app/login_page.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  // TODO refactor
// isLoggedIn =
  var loggedIn = sharedPreferences.getBool('loggedIn');

  if (loggedIn != null || loggedIn == true) {
    print('User was logged in: $loggedIn');
    Map body = {
      "refreshToken": sharedPreferences.getString('refreshToken'),
      "accessToken": sharedPreferences.getString('accessToken')
    };

    String url = "https://wgwebserver.herokuapp.com/user/token";

    var response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      sharedPreferences.setString('accessToken', jsonResponse['accessToken']);
    } else {
      sharedPreferences.clear();
    }
  } else {
    print('User was not logged in: $loggedIn');
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
