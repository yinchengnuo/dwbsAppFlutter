import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageSliver extends StatefulWidget {
  PageSliver({Key key}) : super(key: key);

  @override
  _PageSliverState createState() => _PageSliverState();
}

class _PageSliverState extends State<PageSliver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: 'Sliver'),
      body: Center(
        child: Text('Sliver'),
      ),
    );
  }
}