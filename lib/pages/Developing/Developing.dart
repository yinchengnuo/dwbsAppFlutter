import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class Developing extends StatelessWidget {
  const Developing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '开发中'),
      body: Center(
        child: Text('开发中', style: TextStyle(fontSize: Ycn.px(88))),
      ),
    );
  }
}