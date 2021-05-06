import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:word_guesser_app/models/word.dart';
import 'package:word_guesser_app/routes/word_route.dart';
import '../services/word_services.dart';
import '../constants.dart' as constants;

class NewGuessTab extends StatefulWidget {
  @override
  _GuessTabState createState() => _GuessTabState();
}

class _GuessTabState extends State<NewGuessTab> {
  @override
  Widget build(BuildContext context) {
    // TODO - Add language switch to the top ENG/EST
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
                onPressed: () {
                  setState(() {
                    return build(context);
                  });
                },
                child: Text(
                  'Refresh',
                  style: TextStyle(color: constants.cyan),
                )),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Text("EST "),
                      Text("ENG"),
                    ],
                  ),
                  Text("Word"),
                ],
              )),
              Container(
                child: Text("Answer Options"),
              )
            ],
          ),
        )

        // FutureBuilder(
        //   future: getGuessingWindow(context),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return Column(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [snapshot.data]);
        //     } else {
        //       return Center(child: CircularProgressIndicator());
        //     }
        //   },
        // ),
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
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(constants.cyan)),
      child: Text("${word[0].toUpperCase()}${word.substring(1)}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          : null,
      onLongPress: () async {
        var wordObject = await fetchWord(word, context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WordPage(word: wordObject)),
        );
      },
    );
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
// TODO add infobutton to see definitions
