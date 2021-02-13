import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SavedTab extends StatefulWidget {
  @override
  _SavedTabState createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  List listItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    var url = "https://wgwebserver.herokuapp.com/user/getinfo";
    var res = await http.get(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${sharedPreferences.getString('accessToken')}"
    });
    if (res.statusCode == 200) {
      var words = json.decode(res.body)['words'];
      print(words);
      setState(() {
        listItems = words;
        isLoading = false;
      });
    } else {
      setState(() {
        listItems = [];
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My words'),
        backgroundColor: Colors.cyan[700],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (listItems.contains(null) || listItems.length < 0 || isLoading) {
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
            // TODO Open up a modal to show a word details
          },
        ),
      ),
    );
  }
}
