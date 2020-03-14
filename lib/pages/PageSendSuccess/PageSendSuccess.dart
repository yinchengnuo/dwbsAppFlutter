import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageSendSuccess extends StatefulWidget {
  PageSendSuccess({Key key}) : super(key: key);

  @override
  _PageSendSuccessState createState() => _PageSendSuccessState();
}

class _PageSendSuccessState extends State<PageSendSuccess> {
  @override
  Widget build(BuildContext context) {
    final bool forward = (ModalRoute.of(context).settings.arguments as Map)['forward'];
    return Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white),
        child: Scaffold(
          appBar: Ycn.appBar(context, title: forward ? '转单成功' : '发货成功'),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: Ycn.px(120)),
              Icon(Icons.check_circle, size: Ycn.px(228), color: Theme.of(context).accentColor),
              SizedBox(height: Ycn.px(60)),
              Text(forward ? '转单成功' : '发货成功', style: TextStyle(fontSize: Ycn.px(50))),
              SizedBox(height: Ycn.px(126)),
              Container(
                height: Ycn.px(88),
                width: Ycn.px(480),
                child: FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(88))),
                  child: Text(forward ? '继续审单' : '继续发货', style: TextStyle(color: Colors.white, fontSize: Ycn.px(34))),
                ),
              ),
              SizedBox(height: Ycn.px(30)),
              Container(
                height: Ycn.px(88),
                width: Ycn.px(480),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Ycn.px(88)),
                  border: Border.all(width: Ycn.px(3), color: Theme.of(context).accentColor),
                ),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(88))),
                  child: Text('返回首页', style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(34))),
                ),
              ),
              Expanded(child: Container())
            ],
          ),
        ));
  }
}
