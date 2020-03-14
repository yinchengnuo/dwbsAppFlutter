import 'package:dwbs_app_flutter/apis/app.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import 'package:dwbs_app_flutter/provider/ProviderMessage.dart';
import 'package:provider/provider.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageMessageSystem extends StatefulWidget {
  PageMessageSystem({Key key}) : super(key: key);

  @override
  _PageMessageSystemState createState() => _PageMessageSystemState();
}

class _PageMessageSystemState extends State<PageMessageSystem> {
  bool _loading = false;
  ProviderMessage __message;

  // 批量设置消息为已读
  void _readMessages() {
    if (!this._loading) {
      setState(() => this._loading = true);
    }
    apiReadMessage({'type': 1}).then((status) {
      print(status);
      this.__message.clearUnreadSystemMessages();
    }).whenComplete(() {
      setState(() => this._loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, ProviderMessage message, Widget child) {
      if (this.__message == null) {
        this.__message = message;
        if (this.__message.systemMessageNum > 0) {
          this._loading = true;
          this._readMessages();
        }
      }
      return Loading(
        loading: this._loading,
        child: Scaffold(
          appBar: Ycn.appBar(context, title: '系统通知'),
          body: this.__message.systemMessageNumTotal > 0
              ? ListView.builder(
                  padding: EdgeInsets.all(Ycn.px(30)),
                  itemCount: this.__message.systemMessageNumTotal,
                  itemBuilder: (BuildContext context, int index) => ClipRRect(
                        borderRadius: BorderRadius.circular(Ycn.px(10)),
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: Ycn.px(58),
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: Ycn.px(6),
                                      height: Ycn.px(24),
                                      color: Theme.of(context).accentColor,
                                    ),
                                    SizedBox(width: Ycn.px(11)),
                                    Text(this.__message.systemMessages[index]['title'], style: TextStyle(fontSize: Ycn.px(26), height: 1.25))
                                  ],
                                )),
                            Container(
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(vertical: Ycn.px(1)),
                              padding: EdgeInsets.symmetric(horizontal: Ycn.px(30), vertical: Ycn.px(8)),
                              child: Text(this.__message.systemMessages[index]['message'], style: TextStyle(fontSize: Ycn.px(26), height: 1.75)),
                              // child: RichText(
                              //   text: TextSpan(text: this.__message.systemMessages[index]['message'], children: [
                              //     TextSpan(
                              //         text: 'bold ',
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //         )),
                              //   ]),
                              // ),
                            ),
                            Container(
                              height: Ycn.px(41),
                              color: Colors.white,
                              margin: EdgeInsets.only(bottom: Ycn.px(20)),
                              padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(Ycn.formatTime(this.__message.systemMessages[index]['time']),
                                      style: TextStyle(fontSize: Ycn.px(26), height: 1.25))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
              : Center(
                  child: Text('空空如也...'),
                ),
        ),
      );
    });
  }
}
