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
  bool _isLoading = false;

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
          // TODO if loading, the button decreases, we don\t want that
          child: _isLoading
              ? CircularProgressIndicator()
              : Text("Fetch word",
                  style: TextStyle(fontSize: 32, color: Colors.white)),
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() {
                    _isLoading = true;
                  });
                  if (_wordFieldController.text.length == 0) {
                    Flushbar(
                      message: "Hey dummy! Make sure you entered a word.",
                      duration: Duration(seconds: 3),
                    )..show(context).then(
                        (value) => setState(() {
                          _isLoading = false;
                        }),
                      );
                  } else {
                    var word =
                        await fetchWord(_wordFieldController.text, context);
                    if (word == 'Not found') {
                      Flushbar(
                        message:
                            "The DB could not find this word ${_wordFieldController.text}, check for typos.",
                        duration: Duration(seconds: 3),
                      )..show(context).then(
                          (value) => setState(() {
                            _isLoading = false;
                          }),
                        );
                    } else {
                      showBottomModal(context, word);
                      setState(() {
                        _isLoading = false;
                      });
                    }
                    // TODO  if refreshtoken would be deleted in DB, it starts looping. it should log out.
                  }
                },
        ),
      ],
    );
  }
}
