import 'package:flutter/material.dart';
import 'package:word_guesser_app/login_page.dart';

void main() {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.black),
        home: LoginPage()),
  );
}
