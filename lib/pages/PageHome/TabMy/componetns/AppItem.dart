import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';
import '.././../../../common/components.dart';

class AppItem extends StatelessWidget {
  final img, title, route, number, arguments;
  const AppItem({Key key, this.img, this.title, this.route, this.number = 0, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(90),
      margin: EdgeInsets.only(bottom: Ycn.px(1)),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(route, arguments: this.arguments == null ? {} : this.arguments),
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
                    RedDot(number: this.number),
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
