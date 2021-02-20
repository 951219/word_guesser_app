import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:word_guesser_app/user_services.dart';
import './constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

// TODO delete word
// TODO update score

fetchWord(String word) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String url = '${constants.DOMAIN}/est/get/$word';

  var jsonResponse;
  var res = await http.get(url, headers: {
    HttpHeaders.authorizationHeader:
        "Bearer ${sharedPreferences.getString('accessToken')}"
  });
  jsonResponse = json.decode(res.body);
  if (res.statusCode == 200) {
    return jsonResponse[0];
  } else if (res.statusCode != 403) {
    return jsonResponse['message'];
  } else {
    await syncIsLoggedIn();
    fetchWord(word);
  }
}
