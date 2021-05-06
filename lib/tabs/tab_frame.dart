import 'package:flutter/material.dart';
import 'package:word_guesser_app/tabs/search_tab.dart' as search;
import 'package:word_guesser_app/tabs/saved_tab.dart' as saved;
import 'package:word_guesser_app/tabs/guess_tab.dart' as guess;
import 'package:word_guesser_app/tabs/new_guess_tab.dart' as newguesstab;
import '../constants.dart' as constants;
import '../services/user_services.dart';

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
    tabController = new TabController(length: 4, vsync: this);
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
          constants.appName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: constants.cyan,
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelColor: constants.unSelected,
          labelColor: constants.cyan,
          tabs: [
            Tab(text: 'NewGuess'),
            Tab(text: 'Guess'),
            Tab(text: 'Search'),
            Tab(text: 'Saved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          newguesstab.NewGuessTab(),
          guess.GuessTab(),
          search.SearchTab(),
          saved.SavedTab(),
        ],
      ),
    );
  }
}
