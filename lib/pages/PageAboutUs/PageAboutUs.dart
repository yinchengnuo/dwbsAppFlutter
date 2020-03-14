import 'package:package_info/package_info.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageAboutUs extends StatefulWidget {
  PageAboutUs({Key key}) : super(key: key);

  @override
  _PageAboutUsState createState() => _PageAboutUsState();
}

class _PageAboutUsState extends State<PageAboutUs> {
  String _version = '1.0.0';

  void _getVersion() {
    PackageInfo.fromPlatform().then((res) {
      setState(() {
        this._version = res.version;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    this._getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '关于我们'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: Ycn.px(70)),
              Image.asset('lib/images/public/logo.png', width: Ycn.px(159), height: Ycn.px(159)),
              SizedBox(height: Ycn.px(56)),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('版本信息', style: TextStyle(fontSize: Ycn.px(32))),
                    Text(this._version, style: TextStyle(fontSize: Ycn.px(32))),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: Ycn.px(108),
            alignment: Alignment(0, 0),
            child: Text('— 郑州久卫云科技公司 —'),
          )
        ],
      ),
    );
  }
}
