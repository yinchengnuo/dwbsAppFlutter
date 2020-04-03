import 'package:dwbs_app_flutter/common/Ycn.dart';
import 'package:dwbs_app_flutter/pages/Alphas/PageSliver.dart';
import 'package:flutter/material.dart';

class PageAlpha extends StatefulWidget {
  PageAlpha({Key key}) : super(key: key);

  @override
  _PageAlphaState createState() => _PageAlphaState();
}

class _PageAlphaState extends State<PageAlpha> {
  final List<Map> routerList = [
    {'name': 'Sliver', 'route': PageSliver()},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '开发中'),
      body: SingleChildScrollView(
        child: Wrap(
          children: this.routerList.map((item) {
            return Container(
              margin: EdgeInsets.only(left: 10),
              child: RaisedButton(
                child: Text(item['name'], style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => item['route'])),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
