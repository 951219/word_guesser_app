import 'package:flutter/material.dart';
import 'package:word_guesser_app/widgets/bottom_word_modal.dart';
import '../services/word_services.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController _wordFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
        color: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Text("Fetch word",
            style: TextStyle(fontSize: 32, color: Colors.white)),
        onPressed: () async {
          // TODO check if something is entered, if not then show a snackbar

          var word = await fetchWord(_wordFieldController.text);
          // TODO  if word = error, log the client out
          showBottomModal(context, word);
        },
      ),
    ]);
  }
}
