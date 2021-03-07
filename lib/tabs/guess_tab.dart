import 'package:flutter/material.dart';
import '../services/word_services.dart';

class GuessTab extends StatefulWidget {
  @override
  _GuessTabState createState() => _GuessTabState();
}

class _GuessTabState extends State<GuessTab> {
  @override
  Widget build(BuildContext context) {
    fetchBundle(context);
    return Scaffold(
      body: Center(
        child: Text('Guess now! '),
      ),
    );
  }
}
