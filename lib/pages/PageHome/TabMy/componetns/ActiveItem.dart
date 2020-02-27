import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';

class ActiveItem extends StatelessWidget {
  final img, title, onTap;
  const ActiveItem({Key key, this.img, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: this.onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(this.img, width: Ycn.px(88), height: Ycn.px(88)),
              SizedBox(height: Ycn.px(17)),
              Text(this.title, style: TextStyle(fontSize: Ycn.px(26))),
            ],
          ),
        ),
      ),
    );
  }
}