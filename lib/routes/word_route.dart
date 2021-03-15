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
    bool isInDB;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          Container(
            child: FutureBuilder(
              future: userHasWord(context, wordId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    isInDB = true;
                    return IconButton(
                      icon: Icon(Icons.bookmark),
                      color: Colors.black,
                      onPressed: () async {
                        await removeFromUserDB(context, wordId);
                        setState(() {
                          isInDB = false;
                        });
                      },
                    );
                  } else {
                    isInDB = false;
                    return IconButton(
                      icon: Icon(Icons.bookmark_border),
                      color: Colors.black,
                      onPressed: () async {
                        await saveToUserDB(context, wordId);
                        setState(() {
                          isInDB = true;
                        });
                      },
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          )
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
  // TODO show modal before and then load data so this would prevent spamming.

  return Container(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  word.word.toUpperCase(),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // TODO move to appBar()
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Container(
                            child: InkWell(
                              child: Text('Broken'),
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                      icon: Icon(Icons.settings_rounded, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
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
