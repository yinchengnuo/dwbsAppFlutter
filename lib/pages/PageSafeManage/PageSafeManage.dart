import '../../common/Ycn.dart';
import '../../common/components.dart';
import 'package:flutter/material.dart';

class PageSafeManage extends StatefulWidget {
  PageSafeManage({Key key}) : super(key: key);

  @override
  _PageSafeManageState createState() => _PageSafeManageState();
}

class _PageSafeManageState extends State<PageSafeManage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '安全中心'),
      body: Column(
        children: <Widget>[
          Container(
            height: Ycn.px(90),
            color: Colors.white,
            margin: EdgeInsets.only(bottom: Ycn.px(1)),
            child: MaterialInkWell(
              onTap: () => Navigator.of(context).pushNamed('/address-manage'),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('地址管理', style: TextStyle(fontSize: Ycn.px(32))),
                    Icon(Icons.arrow_forward_ios, size: Ycn.px(30), color: Ycn.getColor('#B7B7B7'))
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: Ycn.px(90),
            color: Colors.white,
            margin: EdgeInsets.only(bottom: Ycn.px(1)),
            child: MaterialInkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('申请退货', style: TextStyle(fontSize: Ycn.px(32))),
                    Icon(Icons.arrow_forward_ios, size: Ycn.px(30), color: Ycn.getColor('#B7B7B7'))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}