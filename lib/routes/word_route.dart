import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:word_guesser_app/models/word.dart';
import 'package:word_guesser_app/routes/google_it_route.dart';
import 'package:word_guesser_app/constants.dart' as constants;

import '../services/user_services.dart';
import '../services/word_services.dart';

class WordPage extends StatefulWidget {
  final Word word;

  WordPage({
    Key key,
    this.word,
  }) : super(key: key);

  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  @override
  Widget build(BuildContext context) {
    // TODO refactor so if would not pull a new word on each rebuild
    var wordId = widget.word.wordId;
    String word = widget.word.word;

    // TODO refactor is in DB to prevent delay when saving
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${word[0].toUpperCase()}${word.substring(1)}",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          Container(
            // TODO - pulling the data each time, the user words should be saved
            // to the local storage and only be updated if there is add or delete/time passes
            child: FutureBuilder(
              future: userHasWord(context, wordId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return IconButton(
                      icon: Icon(Icons.bookmark),
                      color: Colors.black,
                      onPressed: () async {
                        Flushbar(
                          message: "Removed $word from DB",
                          duration: Duration(milliseconds: 1500),
                        )..show(context);
                        await removeFromUserDB(context, wordId);
                        setState(() {
                          build(context);
                        });
                      },
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.bookmark_border),
                      color: Colors.black,
                      onPressed: () async {
                        Flushbar(
                          message: "Added $word to DB",
                          duration: Duration(milliseconds: 1500),
                        )..show(context);
                        await saveToUserDB(context, wordId);
                        setState(() {
                          build(context);
                        });
                      },
                    );
                  }
                } else {
                  return IconButton(
                    icon: Icon(Icons.bookmark_border),
                    onPressed: null,
                  );
                }
              },
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Google it'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('Report broken'),
                value: 1,
              ),
            ],
            onSelected: (value) async {
              if (value == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebViewWidget(word)),
                );
              } else if (value == 1) {
                // TODO close the older flushbar at the same time.
                Flushbar(
                  mainButton: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(constants.cyan)),
                    onPressed: () async {
                      var reported = await postBroken(wordId, word);
                      var msg = 'Thank you!';
                      if (!reported)
                        msg = 'Something went wrong with reporting!';

                      return Flushbar(
                        message: msg,
                        duration: Duration(milliseconds: 1000),
                      )..show(context);
                    },
                    child:
                        Text('Report!', style: TextStyle(color: Colors.white)),
                  ),
                  message: 'Please only report if the word is broken!',
                  duration: Duration(milliseconds: 3000),
                )..show(context);
              }
            },
            icon: Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: FutureBuilder(
          future: getBody(context, widget.word),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class Flatbutton {}

getBody(BuildContext context, Word word) async {
  // TODO Single child scrollable view so longer data would not break the view

  return Container(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            child: (word.meaning.length > 0)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          'Definitions:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _getTextWidgets(word.meaning)),
                      ])
                : Text("No definitions found"),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: (word.example.length > 0)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Examples:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _getTextWidgets(word.example)),
                    ],
                  )
                : Text("No examples found"),
          )
        ],
      ),
    ),
  );
}

List<Widget> _getTextWidgets(List<String> strings) {
  List<Widget> list = [];
  for (String meaning in strings) {
    list.add(Text('* $meaning'));
  }
  return list;
}
