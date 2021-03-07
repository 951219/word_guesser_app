import 'dart:math';

import 'package:flutter/material.dart';
import 'package:word_guesser_app/models/word.dart';
import '../services/word_services.dart';

class GuessTab extends StatefulWidget {
  @override
  _GuessTabState createState() => _GuessTabState();
}

class _GuessTabState extends State<GuessTab> {
  List<Word> list = [];
  Word correctWord;
  // final _random = new Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchBundle(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            list = snapshot.data;
            correctWord = list[Random().nextInt(list.length)];
            list.remove(correctWord);

            // TODO add infobutton to see definitions
            // TODO get 3 randoms and add them to widget with the correct one as well. -> shuffle
            return Container(
                child: Column(
              children: [
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _getTextWidgets(correctWord.meaning)),
                ),
                Container(
                    // TODO buttons
                    )
              ],
            ));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Widget answerButton(Word word) {
  return ElevatedButton(
      onPressed: () {
        // TODO
      },
      child: Text(word.word));
}

List<Widget> _getTextWidgets(List<String> strings) {
  List<Widget> list = [];
  for (String meaning in strings) {
    list.add(Text('* $meaning'));
  }
  return list;
}
