import 'package:flutter/material.dart';
import 'package:word_guesser_app/tabs/search_tab.dart' as search;
import 'package:word_guesser_app/tabs/saved_tab.dart' as saved;
import 'package:word_guesser_app/tabs/guess_tab.dart' as guess;
import 'login_page.dart';
import 'user_services.dart';

class EntryPage extends StatefulWidget {
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout, color: Colors.black),
              tooltip: 'Log out',
              onPressed: () async {
                await logOut(context);
              }),
        ],
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Dictionary',
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.cyan[800],
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelColor: Colors.grey[400],
          labelColor: Colors.cyan[700],
          tabs: [
            Tab(text: 'Guess'),
            Tab(text: 'Search'),
            Tab(text: 'Saved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          guess.GuessTab(),
          search.SearchTab(),
          saved.SavedTab(),
        ],
      ),
    );
  }
}
