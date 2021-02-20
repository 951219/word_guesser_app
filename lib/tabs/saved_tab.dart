import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../user_services.dart';

class SavedTab extends StatefulWidget {
  @override
  _SavedTabState createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  var user;

  @override
  initState() {
    super.initState();
    user = fetchUser();
  }

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

// TODO fix this
  Widget getBody() {
    List _listItems = user['words'];
    if (_isLoading || _listItems.contains(null) || _listItems.length < 0) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    } else if (_listItems.length == 0) {
      return Center(child: Text('You have 0 words'));
    } else {
      return ListView.builder(
          itemCount: _listItems.length,
          itemBuilder: (context, index) {
            return getCard(_listItems[index]);
          });
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
          onTap: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => Container(
                height: 500,
                child: Center(child: Text(word)),
              ),
            );
          },
        ),
      ),
    );
  }
}
