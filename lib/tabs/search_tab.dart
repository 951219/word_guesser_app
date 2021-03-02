import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:word_guesser_app/widgets/bottom_word_modal.dart';
import '../services/word_services.dart';
import '../constants.dart' as constants;

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController _wordFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _wordFieldController,
              decoration: InputDecoration(hintText: "Word"),
            ),
          ),
        ),
        RaisedButton(
          color: constants.cyan,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Text("Fetch word",
              style: TextStyle(fontSize: 32, color: Colors.white)),
          onPressed: () async {
            if (_wordFieldController.text.length == 0) {
              Flushbar(
                message: "Hey dummy! Make sure you entered a word.",
                duration: Duration(seconds: 3),
              )..show(context);
            } else {
              var word = await fetchWord(_wordFieldController.text, context);
              // TODO if no word returned, show a toast
              // TODO  if unauthorized, log out.
              showBottomModal(context, word);
            }
          },
        ),
      ],
    );
  }
}
