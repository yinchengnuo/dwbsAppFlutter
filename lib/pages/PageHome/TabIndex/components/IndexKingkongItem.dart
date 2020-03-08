import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';

class IndexKingkongItem extends StatelessWidget {
  final src, title, route;
  const IndexKingkongItem({Key key, this.src, this.title, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ycn.px(187.5),
      height: Ycn.px(173),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(this.route),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(this.src, width: Ycn.px(88), height: Ycn.px(88)),
              SizedBox(height: Ycn.px(13)),
              Text(this.title, style: TextStyle(fontSize: Ycn.px(32))),
            ],
          ),
        ),
      ),
    );
  }
}
