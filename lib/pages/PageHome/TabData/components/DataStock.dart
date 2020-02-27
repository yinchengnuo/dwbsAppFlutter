import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';

class DataStock extends StatelessWidget {
  final data;
  const DataStock({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(160),
      color: Colors.white,
      margin: EdgeInsets.only(bottom: Ycn.px(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(this.data['my_storage'].toString(), style: TextStyle(fontSize: Ycn.px(36), color: Theme.of(context).accentColor)),
              SizedBox(height: Ycn.px(18)),
              Text('我的库存', style: TextStyle(fontSize: Ycn.px(26))),
            ],
          ),
          SizedBox(width: Ycn.px(1), height: Ycn.px(100), child: Container(color: Theme.of(context).scaffoldBackgroundColor)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(this.data['down_storage'].toString(), style: TextStyle(fontSize: Ycn.px(36), color: Theme.of(context).accentColor)),
              SizedBox(height: Ycn.px(18)),
              Text('下级库存', style: TextStyle(fontSize: Ycn.px(26)))
            ],
          ),
        ],
      ),
    );
  }
}
