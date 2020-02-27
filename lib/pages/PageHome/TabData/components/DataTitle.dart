import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';

class DataTitle extends StatelessWidget {
  final data, title, handle;
  const DataTitle({Key key, this.data, this.title, this.handle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(90),
      color: Colors.white,
      padding: EdgeInsets.only(left: Ycn.px(30)),
      margin: EdgeInsets.only(bottom: Ycn.px(1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(this.title, style: TextStyle(fontSize: Ycn.px(32))),
          Container(
            width: Ycn.px(146),
            height: double.infinity,
            child: Material(
              child: InkWell(
                onTap: this.handle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('更多', style: TextStyle(color: Theme.of(context).textTheme.display1.color, fontSize: Ycn.px(26))),
                    Icon(Icons.arrow_forward_ios, size: Ycn.px(29), color: Theme.of(context).textTheme.display1.color),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
