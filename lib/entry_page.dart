import 'package:flutter/material.dart';
import 'package:word_guesser_app/home.dart' as home;
import 'package:word_guesser_app/fav.dart' as fav;

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
    tabController = new TabController(length: 2, vsync: this);
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
          home.HomeTab(),
          fav.FavTab(),
        ],
      ),
    );
  }
}
