import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageHowToUpdata extends StatefulWidget {
  PageHowToUpdata({Key key}) : super(key: key);

  @override
  _PageHowToUpdataState createState() => _PageHowToUpdataState();
}

class _PageHowToUpdataState extends State<PageHowToUpdata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '如何升级'),
      body: Center(
        child: Text('如何升级'),
      ),
    );
  }
}