import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageApplyReturn extends StatefulWidget {
  PageApplyReturn({Key key}) : super(key: key);

  @override
  _PageApplyReturnState createState() => _PageApplyReturnState();
}

class _PageApplyReturnState extends State<PageApplyReturn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '申请退货'),
      body: Center(
        child: Text('申请退货'),
      ),
    );
  }
}