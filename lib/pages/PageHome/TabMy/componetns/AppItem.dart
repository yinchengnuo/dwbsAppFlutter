import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';
import '.././../../../common/components.dart';

class AppItem extends StatelessWidget {
  final img, title, route, msg;
  const AppItem({Key key, this.img, this.title, this.route, this.msg = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(90),
      margin: EdgeInsets.only(bottom: Ycn.px(1)),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(route),
          child: Container(
            padding: EdgeInsets.fromLTRB(Ycn.px(30), Ycn.px(0), Ycn.px(30), Ycn.px(0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(this.img, width: Ycn.px(38), height: Ycn.px(38)),
                    SizedBox(width: Ycn.px(13)),
                    Text(this.title, style: TextStyle(fontSize: Ycn.px(26)))
                  ],
                ),
                Row(
                  children: <Widget>[
                    this.msg == false
                        ?Container(width: 0, height: 0)
                        : RedDot(number: 999),
                    SizedBox(width: Ycn.px(12)),
                    Icon(Icons.arrow_forward_ios, size: Ycn.px(29), color: Ycn.getColor('#B7B7B7'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
