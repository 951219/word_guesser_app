import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:word_guesser_app/models/word.dart';

showBottomModal(context, Word word) {
  showMaterialModalBottomSheet(
    context: context,
    builder: (context) => Container(
      height: 500,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              word.word,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(word.meaning.toString()),
          SizedBox(
            height: 10,
          ),
          Text(word.example.toString()),
        ],
      ),
    ),
  );
}
