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
    return getBody(context);
  }
}

List<Widget> _getTextWidgets(List<String> strings) {
  List<Widget> list = [];
  for (String meaning in strings) {
    list.add(Text('* $meaning'));
  }
  return list;
}

Container getBody(BuildContext context) {
  List<Word> list = [];
  Word correctWord;

  List<Widget> topPart;
  Widget firstOption;
  Widget secondOption;
  Widget thirdOption;
  Widget fourthOption;

  FutureBuilder(
    future: fetchBundle(context),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        list = snapshot.data;
        correctWord = list[Random().nextInt(list.length)];
        list.shuffle();

        // TODO add infobutton to see definitions
        // TODO get 3 randoms and add them to widget with the correct one as well. -> shuffle

        topPart = _getTextWidgets(correctWord.meaning);
        firstOption = Text(list[0].word);
        secondOption = Text(list[1].word);
        thirdOption = Text(list[2].word);
        fourthOption = Text(list[3].word);
        return Flushbar(
          message: "We got the data!",
          duration: Duration(seconds: 3),
        )..show(context);
      } else {
        topPart = [CircularProgressIndicator()];
        firstOption = CircularProgressIndicator();
        secondOption = CircularProgressIndicator();
        thirdOption = CircularProgressIndicator();
        fourthOption = CircularProgressIndicator();
      }
    },
  );

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
