import 'package:flutter/material.dart';
import 'package:word_guesser_app/widgets/bottom_word_modal.dart';
import '../services/user_services.dart';
import '../services/word_services.dart';

class SavedTab extends StatefulWidget {
  @override
  _SavedTabState createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getBody(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return snapshot.data;
          }
        },
      ),
    );
  }

  Future<Widget> getBody() async {
    var user = await fetchUser(context);
    List _listItems = user['words'];

    if (_listItems.contains(null) || _listItems.length < 0) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    } else if (_listItems.length == 0) {
      return Center(
        child: Text('You have 0 words'),
      );
    } else {
      return ListView.builder(
        itemCount: _listItems.length,
        itemBuilder: (context, index) {
          return getCard(_listItems[index]);
        },
      );
    }
  }

  Widget getCard(item) {
    var word = item['word'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word,
                    style: TextStyle(fontSize: 27),
                  ),
                  Text(
                    'data',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              )
            ],
          ),
          onTap: () async {
            var wordObject = await fetchWord(word);
            showBottomModal(context, wordObject);
          },
        ),
      ),
    );
  }
}
