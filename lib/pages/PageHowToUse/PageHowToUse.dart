import 'package:flutter/material.dart';
import '../../common/Ycn.dart';

class PageHowToUse extends StatelessWidget {
  const PageHowToUse({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '如何使用'),
      body: Container(
        child: SingleChildScrollView(
          child: Image.asset('lib/images/public/how-to-use.png'),
        ),
      ),
    );
  }
}
