import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:word_guesser_app/models/word.dart';
import 'package:word_guesser_app/services/user_services.dart';
import '../constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

// TODO update score
fetchWord(String word, BuildContext context) async {
  print("Calling: $word");
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String url = '${constants.DOMAIN}/est/get/$word';

  var res = await http.get(url, headers: {
    HttpHeaders.authorizationHeader:
        "Bearer ${sharedPreferences.getString('accessToken')}"
  });

  var jsonData = json.decode(res.body);

  if (res.statusCode == 200) {
    Word word = Word.fromJson(jsonData[0]);
    return word;
  } else if (res.statusCode == 403) {
    print(jsonData['message']);
    await syncIsLoggedIn();
    return fetchWord(word, context);
  } else if (res.statusCode == 401) {
    print('You are unauthorized to view it, Logging out.' +
        '\nerror: ${jsonData['message']}');
    logOut(context);
  } else if (res.statusCode == 404) {
    print('Word \'$word\' not found');
    return 'Not found';
  } else {
    print('Error: $jsonData');
    logOut(context);
  }
}

postBroken(int wordId, String word) async {
  print('postBroken()');
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  Map body = {"word": word, "wordId": wordId.toString()};

  var url = "${constants.DOMAIN}/est/postbroken";
  var res = await http.post(
    url,
    body: body,
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${sharedPreferences.getString('accessToken')}"
    },
  );

  if (res.statusCode == 200) {
    return true;
  } else {
    print(
        "Error: Response status: ${res.statusCode} \n ${json.decode(res.body)}");
    return false;
  }
}

Future<List<dynamic>> fetchBundle(BuildContext context) async {
  const wordAmount = 4;

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String url = '${constants.DOMAIN}/est/random/$wordAmount';

  var res = await http.get(url, headers: {
    HttpHeaders.authorizationHeader:
        "Bearer ${sharedPreferences.getString('accessToken')}"
  });

  var jsonData = json.decode(res.body);
  List<Word> list = [];

  if (res.statusCode == 200) {
    print('Got the words - response: 200');
    await jsonData.forEach((item) => list.add(Word.fromJson(item)));
    return list;
  } else if (res.statusCode == 403) {
    print(jsonData['message']);
    await syncIsLoggedIn();
    return fetchBundle(context);
  } else if (res.statusCode == 401) {
    print('You are unauthorized to view it, Logging out.' +
        '\nerror: ${jsonData['message']}');
    logOut(context);
  } else if (res.statusCode == 404) {
    print('Not found');
  } else {
    print('Error: $jsonData');
    logOut(context);
  }
  return list;
}
