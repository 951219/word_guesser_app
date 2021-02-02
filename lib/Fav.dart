import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavTab extends StatefulWidget {
  @override
  _FavTabState createState() => _FavTabState();
}

class _FavTabState extends State<FavTab> {
  List listItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    var url =
        "https://wgwebserver.herokuapp.com/testing/getinfowithuserid/123456";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var words = json.decode(response.body)['words'];
      setState(() {
        listItems = words;
        isLoading = false;
      });
    } else {
      setState(() {
        listItems = [];
        isLoading = false;
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
        ),
      ),
    );
  }
}
