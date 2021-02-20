import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';
import '../user_services.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController _wordFieldController = TextEditingController();
  var definiton = "";

  _fetchWord(String word) async {
    //TODO Starts looping if accesstoken is expired
    if (_wordFieldController.text != null || _wordFieldController.text != "") {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String url = '${constants.DOMAIN}/est/get/$word';

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
      } else if (res.statusCode == 200) {
        setState(() {
          definiton = jsonResponse['message'];
        });
      } else {
        // TODO debug - Starts spamming if the word does not exist
        await syncIsLoggedIn();
        _fetchWord(word);
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
