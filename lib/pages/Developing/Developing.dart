
import 'package:dwbs_app_flutter/common/Ycn.dart';
import 'package:flutter/material.dart';

class Developing extends StatefulWidget {
  Developing({Key key}) : super(key: key);

  @override
  _DevelopingState createState() => _DevelopingState();
}

class _DevelopingState extends State<Developing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '开发中'),
      body: Center(
        child: Text('开发中'),
      ),
    );
  }
}