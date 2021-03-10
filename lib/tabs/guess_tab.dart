import 'dart:math';

import 'package:flutter/material.dart';
import 'package:word_guesser_app/models/word.dart';
import '../services/word_services.dart';

class GuessTab extends StatefulWidget {
  @override
  _GuessTabState createState() => _GuessTabState();
}

class _GuessTabState extends State<GuessTab> {
  @override
  Widget build(BuildContext context) {
    return getBody(context);
  }
}

Scaffold getBody(BuildContext context) {
  return Scaffold(
    body: FutureBuilder(
      future: fetchBundle(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return getGuessingWindow(snapshot.data);

          // TODO add infobutton to see definitions
          // TODO get 3 randoms and add them to widget with the correct one as well. -> shuffle

        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}

Widget getGuessingWindow(List<Word> words) {
  List<Word> list = words;
  list.shuffle();
  Word correctWord = list[Random().nextInt(list.length)];

  List<Text> topPart = correctWord.meaning.map((e) => Text('* $e')).toList();
  Widget firstOption = Text(list[0].word);
  Widget secondOption = Text(list[1].word);
  Widget thirdOption = Text(list[2].word);
  Widget fourthOption = Text(list[3].word);

  return Container(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(child: Column(children: topPart ?? [Container()])),
          Container(
            color: Colors.greenAccent,
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(onPressed: () {}, child: firstOption),
                      TextButton(onPressed: () {}, child: secondOption)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(onPressed: () {}, child: thirdOption),
                      TextButton(onPressed: () {}, child: fourthOption)
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
// TODO checkIfCorrect()

// TODO Next button
// TODO onLongpress() => fetch the word and show word route
