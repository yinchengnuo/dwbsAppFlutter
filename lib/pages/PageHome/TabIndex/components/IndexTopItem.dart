import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';

class IndexTopItem extends StatelessWidget {
  final src, title, route;
  const IndexTopItem({Key key, this.src, this.title, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ycn.px(250),
      height: Ycn.px(180),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(this.route),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(this.src, width: Ycn.px(96.7), height: Ycn.px(96.7)),
              SizedBox(height: Ycn.px(8)),
              Text(this.title, style: TextStyle(fontSize: Ycn.px(32))),
            ],
          ),
        ),
      ),
    );
  }
}
