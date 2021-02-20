import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart' as constants;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_services.dart';

class SavedTab extends StatefulWidget {
  @override
  _SavedTabState createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  List listItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    //TODO Starts looping if accesstoken is expired
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });

    var url = "${constants.DOMAIN}/user/getinfo";
    var res = await http.get(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${sharedPreferences.getString('accessToken')}"
    });
    if (res.statusCode == 200) {
      var words = json.decode(res.body)['words'];
      print("Response status: ${res.statusCode} - Got the words");
      setState(() {
        listItems = words;
        _isLoading = false;
      });
    } else if (res.statusCode == 403) {
      print(
          "Response status: ${res.statusCode} - Sending a request to get a new access token");
      await syncIsLoggedIn();
      fetchUser();
    } else {
      print("Response status: ${res.statusCode}");
      setState(() {
        listItems = [];
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    // If jwt expired, log out.

    if (_isLoading || listItems.contains(null) || listItems.length < 0) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    } else if (listItems.length == 0) {
      return Center(child: Text('You have 0 words'));
    } else {
      return ListView.builder(
          itemCount: listItems.length,
          itemBuilder: (context, index) {
            return getCard(listItems[index]);
          });
    }
  }

  Widget getCard(item) {
    var word = item['word'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word,
                    style: TextStyle(fontSize: 27),
                  ),
                  Text(
                    'data',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              )
            ],
          ),
          onTap: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => Container(
                height: 500,
                child: Center(child: Text(word)),
              ),
            );
          },
        ),
      ),
    );
  }
}
