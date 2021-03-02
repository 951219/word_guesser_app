import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:word_guesser_app/services/user_services.dart';
import 'package:word_guesser_app/tab_frame.dart';
import 'constants.dart' as constants;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(hintText: "Username"),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(hintText: "Password"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: constants.cyan,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text("Sing in",
                          style: TextStyle(fontSize: 32, color: Colors.white)),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_usernameController.text.length == 0 ||
                              _passwordController.text.length == 0) {
                            Flushbar(
                              message:
                                  "Hey dummy! Make sure you entered both password and username",
                              duration: Duration(seconds: 3),
                            )..show(context);
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            var result = await singIn(_usernameController.text,
                                _passwordController.text, context);

                            if (result) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EntryPage(),
                                  ),
                                  (Route<dynamic> route) => false);
                            } else {
                              Flushbar(
                                message:
                                    "Oopsie! Server said no-no, please check your credentials",
                                duration: Duration(seconds: 3),
                              )..show(context).then(
                                  (value) => setState(
                                    () {
                                      _isLoading = false;
                                    },
                                  ),
                                );
                            }
                          }
                        },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  child: Text('Forgot Password'),
                  onPressed: () {
                    Flushbar(
                      message: "Psst! This part is not yet ready",
                      duration: Duration(seconds: 3),
                    )..show(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
