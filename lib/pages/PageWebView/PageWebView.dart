import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PageWebView extends StatelessWidget {
  const PageWebView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if (args['url'].toString().indexOf('http') != 0) {
      Navigator.of(context).pop();
    }
    return Scaffold(
      body: SafeArea(
          child: WebView(
        initialUrl: args['url'],
        javascriptMode: JavascriptMode.unrestricted,
      )),
    );
  }
}
