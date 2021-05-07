import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:word_guesser_app/models/word.dart';
import 'package:word_guesser_app/routes/word_route.dart';
import '../services/user_services.dart';
import '../services/word_services.dart';

class SavedTab extends StatefulWidget {
  @override
  _SavedTabState createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getBody(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return snapshot.data;
          }
        },
      ),
    );
  }

  Future<Widget> getBody() async {
    var user = jsonDecode(await getUser(context));
    List _listItems = user['words'];

    if (_listItems.contains(null) || _listItems.length < 0) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    } else if (_listItems.length == 0) {
      return Center(
        child: Text('You have 0 words'),
      );
    } else {
      return ListView.builder(
        itemCount: _listItems.length,
        itemBuilder: (context, index) {
          return getCard(_listItems[index]);
        },
      );
    }
  }

  Widget getCard(item) {
    var word = item['word'].toString();
    return Card(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: ListTile(
          contentPadding: EdgeInsets.all(8),
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${word[0].toUpperCase()}${word.substring(1)}",
                    style: TextStyle(fontSize: 24),
                  ),
                  // Text(
                  //   "item",
                  //   // TODO add data
                  //   style: TextStyle(fontSize: 17),
                  // ),
                ],
              )
            ],
          ),
          onTap: () async {
            Word wordObject = await fetchWord(word, context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WordPage(word: wordObject)),
            );
            // Disable click action if pressed already ro prevent multiple clicks
          },
        ),
      ),
    );
  }
}
