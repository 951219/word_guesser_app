import 'package:shared_preferences/shared_preferences.dart';

void checkTokens() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //Check if the old token is still valid
  //Get a new accessToken by passing refreshToken
}

// TODO

// POST http://localhost:5000/user/token
// Content-Type: application/json
// {
//     "token": ""
// }

// This will return a new access token

// authenticateUser(){
// If current token is not valid, ask for a new access token from API
// }
