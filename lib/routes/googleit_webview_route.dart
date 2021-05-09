import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatelessWidget {
  WebViewWidget(this.word);

  final String word;

  @override
  Widget build(BuildContext context) {
    print("test");
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: 'https://www.google.com/search?q=$word',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
