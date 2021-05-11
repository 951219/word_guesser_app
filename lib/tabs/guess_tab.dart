import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:word_guesser_app/models/word.dart';
import 'package:word_guesser_app/routes/word_route.dart';
import '../services/word_services.dart';
import '../constants.dart' as constants;

class GuessTab extends StatefulWidget {
  @override
  _GuessTabState createState() => _GuessTabState();
}

class _GuessTabState extends State<GuessTab> {
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
      body: FutureBuilder(
        future: getGuessingWindow(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
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
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(constants.cyan)),
      child: Text("${word[0].toUpperCase()}${word.substring(1)}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      onPressed: isEnabled
          ? () => {
                if (correctWord.word == word)
                  {
                    Flushbar(
                      message: "Correct! Yay!!!",
                      duration: Duration(milliseconds: 1500),
                    ).show(context)
                  }
                else
                  {
                    Flushbar(
                      message: "Nope, try again.",
                      duration: Duration(milliseconds: 1500),
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

  List<Container> topPart = correctWord.meaning
      .map(
        (e) => Container(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            '* $e',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TODO make the top part scrollable so bigger text wont break it
          Column(children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Can you guess the word?",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: topPart ?? [Container()])),
          ]),

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

// TODO positioning on the page
// TODO report brokenBundle()
// TODO add infobutton to see definitions
// TODO make it scrollable so longer text heavy words would not break it
// TODO if no definitions/examples returned, show an error
