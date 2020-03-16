import 'package:dwbs_app_flutter/common/EventBus.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

const List appData = [
  {
    'title': '如何绑定手机号？',
    'content': '在“我的”页面里点击“实名认证”，在弹出的页面中填写详细的 用户信息资料，填写完毕好点击提交按钮即可认证完成。',
  },
  {
    'title': '如何进行实名认证？',
    'content': '在“我的”页面里点击“实名认证”，在弹出的页面中填写详细的 用户信息资料，填写完毕好点击提交按钮即可认证完成。',
  },
  {
    'title': '如何绑定手机号？',
    'content': '在“我的”页面里点击“实名认证”，在弹出的页面中填写详细的 用户信息资料，填写完毕好点击提交按钮即可认证完成。',
  },
  {
    'title': '如何订货下单？',
    'content': '在“我的”页面里点击“实名认证”，在弹出的页面中填写详细的 用户信息资料，填写完毕好点击提交按钮即可认证完成。',
  },
  {
    'title': '如何分享邀请链接？',
    'content': '在“我的”页面里点击“实名认证”，在弹出的页面中填写详细的 用户信息资料，填写完毕好点击提交按钮即可认证完成。',
  },
  {
    'title': '如何查看授权书？',
    'content': '在“我的”页面里点击“实名认证”，在弹出的页面中填写详细的 用户信息资料，填写完毕好点击提交按钮即可认证完成。',
  },
  {
    'title': '如何转上级发货？',
    'content': '在“我的”页面里点击“实名认证”，在弹出的页面中填写详细的 用户信息资料，填写完毕好点击提交按钮即可认证完成。',
  },
];

class PageProblemHelp extends StatefulWidget {
  PageProblemHelp({Key key}) : super(key: key);

  @override
  _PageProblemHelpState createState() => _PageProblemHelpState();
}

class _PageProblemHelpState extends State<PageProblemHelp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '问题帮助'),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: Ycn.px(270),
                color: Theme.of(context).accentColor,
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(35)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: Ycn.px(41)),
                    Text('在线客服', style: TextStyle(color: Colors.white, fontSize: Ycn.px(48))),
                    SizedBox(height: Ycn.px(21)),
                    Text('客服服务时间：9:00-21:00', style: TextStyle(color: Colors.white, fontSize: Ycn.px(30))),
                    SizedBox(height: Ycn.px(18)),
                    Text('双休、节假日：10:17:30', style: TextStyle(color: Colors.white, fontSize: Ycn.px(30))),
                    SizedBox(height: Ycn.px(18)),
                    Row(
                      children: <Widget>[
                        Container(
                          width: Ycn.px(144),
                          height: Ycn.px(46),
                          alignment: Alignment(0, 0),
                          decoration: BoxDecoration(border: Border.all(width: Ycn.px(2), color: Colors.white)),
                          child: Text('联系客服', style: TextStyle(color: Colors.white, fontSize: Ycn.px(24))),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Positioned(right: 0, bottom: 0, child: Icon(Icons.headset, color: Colors.white, size: Ycn.px(240)))
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: appData.length,
              separatorBuilder: (context, index) => Container(height: Ycn.px(1)),
              itemBuilder: (context, index) => Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    EventBus().emit('PANELCLOSE');
                    EventBus().emit('PANELOPEN', index);
                  },
                  child: CustomPanelItem(index: index),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomPanelItem extends StatefulWidget {
  final index;
  CustomPanelItem({Key key, this.index}) : super(key: key);

  @override
  _CustomPanelItemState createState() => _CustomPanelItemState(this.index);
}

class _CustomPanelItemState extends State<CustomPanelItem> with SingleTickerProviderStateMixin {
  final _index;
  double _height;
  bool _opening = false;
  Animation<double> animation;
  AnimationController controller;
  _CustomPanelItemState(this._index);

  @override
  void initState() {
    super.initState();
    EventBus().on('PANELOPEN', (index) {
      if (index == this._index && mounted) {
        setState(() {
          this._opening = true;
          controller.forward();
        });
      }
    });
    EventBus().on('PANELCLOSE', (index) {
      if (this._opening && mounted) {
        setState(() {
          this._opening = false;
          controller.reverse();
        });
      }
    });
    _height = Ycn.px((appData[this._index]['content'].toString().length / 28).ceil() * 40 + 36);
    controller = AnimationController(duration: const Duration(milliseconds: 123), vsync: this);
    animation = Tween(begin: 0.0, end: this._height).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: Ycn.px(90),
          padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                appData[this._index]['title'],
                style: TextStyle(
                  fontSize: Ycn.px(30),
                  color: this._opening ? Theme.of(context).accentColor : Theme.of(context).textTheme.body1.color,
                ),
              ),
              Transform.rotate(
                angle: 3.13415926 / 2 * (animation.value / this._height),
                child: Container(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: this._opening ? Theme.of(context).accentColor : Ycn.getColor('#B7B7B7'),
                    size: Ycn.px(30),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: animation.value,
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: Ycn.px(18), horizontal: Ycn.px(30)),
          child: Text(appData[this._index]['content'], style: TextStyle(fontSize: Ycn.px(26), height: 1.5)),
        ),
      ],
    );
  }
}
