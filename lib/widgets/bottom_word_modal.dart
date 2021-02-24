import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:word_guesser_app/models/word.dart';
import '../services/user_services.dart';

showBottomModal(context, Word word) {
  showMaterialModalBottomSheet(
    context: context,
    builder: (context) => Container(
      height: 600,
      child: Padding(
        padding: EdgeInsets.all(15),
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
                      FutureBuilder(
                          future: userHasWord(context, word.wordId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data == true) {
                                return IconButton(
                                    icon: Icon(Icons.bookmark),
                                    onPressed: () {});
                              } else {
                                return IconButton(
                                    icon: Icon(Icons.bookmark_border),
                                    onPressed: () {});
                              }
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: InkWell(
                              child: Text('Save'),
                              onTap: null,
                              // TODO
                            ),
                          ),
                          PopupMenuItem(
                            child: InkWell(
                              child: Text('Broken'),
                              onTap: null,
                              // TODO
                            ),
                          ),
                          PopupMenuItem(
                            child: InkWell(
                              child: Text('Delete'),
                              onTap: null,
                              // TODO
                            ),
                          ),
                        ],
                        child: Icon(Icons.settings_rounded, size: 30),
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
                children: getTextWidgets(word.meaning)),
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
                children: getTextWidgets(word.example))
          ],
        ),
      ),
    ),
  );
}

List<Widget> getTextWidgets(List<String> strings) {
  List list = new List<Widget>();
  for (var i = 0; i < strings.length; i++) {
    list.add(Text('* ${strings[i]}'));
  }
  return list;
}
