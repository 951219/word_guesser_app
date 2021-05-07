import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:word_guesser_app/models/word.dart';

import '../services/user_services.dart';

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
                enabled: false,
                child: Text('Google it'),
                value: 0,
              ),
              PopupMenuItem(
                enabled: false,
                child: Text('Report broken'),
                value: 1,
              ),
            ],
            onSelected: (value) {
              Flushbar(
                message: "Congratz, you pressed $value",
                duration: Duration(milliseconds: 1500),
              )..show(context);
              // TODO Google it
              // TODO Report it
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
          // TODO if no definitions, show an error
          Text(
            'Definitions:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: _getTextWidgets(word.meaning)),
          SizedBox(
            height: 20,
          ),
          // TODO if no examples, show an error
          Text(
            'Examples:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: _getTextWidgets(word.example))
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
