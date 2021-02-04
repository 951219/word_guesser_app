import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  TextEditingController _wordFieldController = TextEditingController();
  var definiton = "";

  _fetchWord(String word) async {
    if (_wordFieldController.text != null || wordFieldController.text != "") {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String url = 'https://wgwebserver.herokuapp.com/est/get/${word}';

      var jsonResponse;
      var res = await http.get(url, headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${sharedPreferences.getString('accessToken')}"
      });

      if (res.statusCode == 200) {
        jsonResponse = json.decode(res.body);
        setState(() {
          definiton = jsonResponse[0]['meaning'].toString();
        });
      }
    } else {
      setState(() {
        definiton = "Please check if you added a word";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _wordFieldController,
            decoration: InputDecoration(hintText: "Word"),
          ),
        ),
      ),
      RaisedButton(
        color: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Text("Fetch word",
            style: TextStyle(fontSize: 32, color: Colors.white)),
        onPressed: () {
          _fetchWord(_wordFieldController.text);
        },
      ),
      definiton != null ? Text(definiton) : null
    ]);
  }
}
