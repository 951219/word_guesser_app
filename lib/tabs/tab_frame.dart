import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:word_guesser_app/tabs/search_tab.dart' as search;
import 'package:word_guesser_app/tabs/saved_tab.dart' as saved;
import 'package:word_guesser_app/tabs/guess_tab.dart' as guess;
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
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
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
            Tab(text: 'Guess'),
            Tab(text: 'Search'),
            Tab(text: 'Saved'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 120,
              child: DrawerHeader(
                child: Text(
                  constants.appName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                decoration: BoxDecoration(color: constants.cyan),
              ),
            ),
            ListTile(
                trailing: Icon(Icons.portrait, color: Colors.black),
                title: Text("Profile"),
                onTap: () {
                  Flushbar(
                    message: "Not implemented yet...",
                    duration: Duration(seconds: 3),
                  )..show(context);
                }),
            ListTile(
              trailing: Icon(Icons.logout, color: Colors.black),
              title: Text("Log out"),
              onTap: () async {
                await logOut(context);
              },
            )
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
