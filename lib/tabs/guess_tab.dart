import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
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
  bool btnEnabled = true;

  Widget getBtn(String word, bool isEnabled) {
    return ElevatedButton(
        child: Text(word, style: TextStyle(color: Colors.black)),
        onPressed: isEnabled
            ? () => {
                  if (checkIfCorrect(correctWord, word))
                    {
                      Flushbar(
                        message: "Correct! Yay!!!",
                        duration: Duration(seconds: 3),
                      ).show(context)
                    }
                  else
                    {
                      Flushbar(
                        message: "Nope, try again.",
                        duration: Duration(seconds: 3),
                      )..show(context)
                    },
                }
            : null);
  }

  List<Text> topPart = correctWord.meaning
      .map(
        (e) => Text(
          '* $e',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      )
      .toList();
  Widget firstOption = getBtn(list[0].word, btnEnabled);
  Widget secondOption = getBtn(list[1].word, btnEnabled);
  Widget thirdOption = getBtn(list[2].word, btnEnabled);
  Widget fourthOption = getBtn(list[3].word, btnEnabled);

  return Container(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(child: Column(children: topPart ?? [Container()])),
          Container(
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [firstOption, secondOption],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [thirdOption, fourthOption],
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

// TODO positioning on the page
// TODO report brokenBundle()
// TODO onLongpress() => fetch the word and show word route
// TODO add infobutton to see definitions
