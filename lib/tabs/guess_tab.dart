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

Scaffold getBody(BuildContext context) {
  List<Word> list = [];
  Word correctWord;
  return Scaffold(
    body: Container(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            FutureBuilder(
              future: fetchBundle(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  list = snapshot.data;
                  correctWord = list[Random().nextInt(list.length)];
                  list.shuffle();

                  // TODO add infobutton to see definitions
                  // TODO get 3 randoms and add them to widget with the correct one as well. -> shuffle
                  return Column(
                    children: [
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _getTextWidgets(correctWord.meaning)),
                      ),
                      Container(
                        child: Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(list[0].word)),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(list[1].word))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(list[2].word)),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(list[3].word))
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    ),
  );
}

// TODO checkIfCorrect()
