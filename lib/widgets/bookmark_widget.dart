import 'package:flutter/material.dart';

import '../services/user_services.dart';

class BookMarkWidget extends StatefulWidget {
  int wordId;
  BookMarkWidget({@required this.wordId});

  @override
  _BookMarkWidgetState createState() => _BookMarkWidgetState();
}

class _BookMarkWidgetState extends State<BookMarkWidget> {
  bool hasWord;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userHasWord(context, widget.wordId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          hasWord = snapshot.data == true;
          if (hasWord) {
            return IconButton(
              icon: Icon(Icons.bookmark),
              onPressed: () async {
                await removeFromUserDB(widget.wordId);
                setState(() {
                  hasWord = false;
                });
              },
            );
          } else {
            return IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed: () async {
                await saveToUserDB(widget.wordId);
                setState(() {
                  hasWord = true;
                });
              },
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
