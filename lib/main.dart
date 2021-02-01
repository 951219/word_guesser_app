import 'package:flutter/material.dart';
import 'package:word_guesser_app/Home.dart' as Home;
import 'package:word_guesser_app/Fav.dart' as Fav;
import 'package:word_guesser_app/dbhelp.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController tabController;

  DbHelp dbHelp;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);

    dbHelp = new DbHelp();
    dbHelp.db;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Tab(text: 'Home'),
            Tab(
              text: 'Fav',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Home.HomeTab(),
          Fav.FavTab(),
        ],
      ),
    );
  }
}
