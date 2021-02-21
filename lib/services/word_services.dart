import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:word_guesser_app/models/word.dart';
import 'package:word_guesser_app/services/user_services.dart';
import '../constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

// TODO delete word
// TODO update score

Future<Word> fetchWord(String word) async {
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
    fetchWord(word);
  } else {
    print('Some other error: ${jsonData['message']}');
  }
}