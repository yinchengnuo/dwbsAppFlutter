import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart'; // 引入工具库

class CommListItemTop extends StatelessWidget {
  final data;
  const CommListItemTop({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(81),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(radius: Ycn.px(40.5), backgroundImage: NetworkImage(data['avatar'])),
              SizedBox(width: Ycn.px(18)),
              Text(data['author'], style: TextStyle(fontSize: Ycn.px(28))),
              SizedBox(width: Ycn.px(18)),
              Container(
                width: Ycn.px(56),
                height: Ycn.px(28),
                alignment: Alignment(0, 0),
                decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(Ycn.px(2))),
                child: Text('官方', style: TextStyle(color: Colors.white, fontSize: Ycn.px(20))),
              ),
            ],
          ),
          Text(Ycn.formatTime(data['created_at']), style: TextStyle(fontSize: Ycn.px(24)))
        ],
      ),
    );
  }
}
