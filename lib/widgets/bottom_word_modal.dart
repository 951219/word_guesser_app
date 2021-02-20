import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

showBottomModal(context, word) {
  showMaterialModalBottomSheet(
    context: context,
    builder: (context) => Container(
      height: 500,
      child: Column(
        children: [
          Text(word['word']),
          SizedBox(
            height: 10,
          ),
          Text(word['meaning'].toString()),
          SizedBox(
            height: 10,
          ),
          Text(word['exampe'].toString()),
        ],
      ),
    ),
  );
}
