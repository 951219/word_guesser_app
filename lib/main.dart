import 'package:flutter/material.dart';
import 'package:word_guesser_app/tabs/tab_frame.dart';
import 'package:word_guesser_app/routes/login_route.dart';
import 'services/user_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black),
      home: FutureBuilder<bool>(
        future: syncIsLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return EntryPage();
            } else {
              return LoginPage();
            }
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    ),
  );
}
