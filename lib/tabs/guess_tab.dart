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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: FutureBuilder(
              future: getGuessingWindow(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Center(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          return build(context);
                        });
                      },
                      child: Text('Refresh')),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

getGuessingWindow(BuildContext context) async {
  List<Word> list = await fetchBundle(context);
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
          ),
        ],
      ),
    ),
  );
}

bool checkIfCorrect(Word correctWord, String word) {
  if (correctWord.word == word) {
    return true;
  } else {
    return false;
  }
}
// TODO onLongpress() => fetch the word and show word route
// TODO add infobutton to see definitions
