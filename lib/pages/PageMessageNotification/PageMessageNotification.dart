import '../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import 'package:dwbs_app_flutter/provider/ProviderMessage.dart';

class PageMessageNotification extends StatefulWidget {
  PageMessageNotification({Key key}) : super(key: key);

  @override
  _PageMessageNotificationState createState() => _PageMessageNotificationState();
}

class _PageMessageNotificationState extends State<PageMessageNotification> {
  ProviderMessage __message;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, ProviderMessage message, Widget child) {
      this.__message = message;
      return Scaffold(
        appBar: Ycn.appBar(context, title: '消息通知'),
        body: RefreshIndicator(
          onRefresh: this.__message.getMessage,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                  height: Ycn.px(136),
                  color: Colors.white,
                  margin: EdgeInsetsDirectional.only(bottom: Ycn.px(1)),
                  child: MaterialInkWell(
                    onTap: () => Navigator.of(context).pushNamed('/message-order'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Ycn.px(30), vertical: Ycn.px(20)),
                      child: Row(
                        children: <Widget>[
                          Image.asset('lib/images/public/order-msg.png', width: Ycn.px(88), height: Ycn.px(88)),
                          SizedBox(width: Ycn.px(24)),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('订单通知', style: TextStyle(fontSize: Ycn.px(32), height: 1.5)),
                                Text(
                                  this.__message.previewOrderMessageText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).textTheme.display1.color),
                                ),
                                SizedBox(height: Ycn.px(0))
                              ],
                            ),
                          ),
                          RedDot(number: this.__message.orderMessageNum)
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: Ycn.px(136),
                  color: Colors.white,
                  child: MaterialInkWell(
                    onTap: () => Navigator.of(context).pushNamed('/message-system'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Ycn.px(30), vertical: Ycn.px(20)),
                      child: Row(
                        children: <Widget>[
                          Image.asset('lib/images/public/system-msg.png', width: Ycn.px(88), height: Ycn.px(88)),
                          SizedBox(width: Ycn.px(24)),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('系统推送', style: TextStyle(fontSize: Ycn.px(32), height: 1.5)),
                                Text(
                                  this.__message.previewSystemMessageText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).textTheme.display1.color),
                                ),
                                SizedBox(height: Ycn.px(0))
                              ],
                            ),
                          ),
                          RedDot(number: this.__message.systemMessageNum)
                        ],
                      ),
                    ),
                  ),
                ),
                Container(height: Ycn.screenH() - Ycn.mediaQuery.padding.top - Ycn.mediaQuery.padding.bottom - Ycn.px(359))
              ],
            ),
          ),
        ),
      );
    });
  }
}
