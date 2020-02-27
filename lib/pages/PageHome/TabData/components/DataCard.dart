import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';

class DataCard extends StatelessWidget {
  final title, content;
  const DataCard({Key key, this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(345),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(Ycn.px(10)),
            child: Image.asset('lib/images/public/data-card.png', width: Ycn.px(706), height: Ycn.px(316)),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(this.title, style: TextStyle(color: Colors.white, fontSize: Ycn.px(32))),
                SizedBox(height: Ycn.px(59)),
                Text(this.content, style: TextStyle(color: Colors.white, fontSize: Ycn.px(70)))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
