import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageUpdataStatus extends StatefulWidget {
  PageUpdataStatus({Key key}) : super(key: key);

  @override
  _PageUpdataStatusState createState() => _PageUpdataStatusState();
}

class _PageUpdataStatusState extends State<PageUpdataStatus> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white),
      child: Scaffold(
        appBar: Ycn.appBar(context, title: '确定订单'),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: Ycn.px(145)),
            Icon(Icons.check_circle, color: Theme.of(context).accentColor, size: Ycn.px(228)),
            SizedBox(height: Ycn.px(100)),
            Text('下单成功，请等待审核确认...', style: TextStyle(fontSize: Ycn.px(36))),
            SizedBox(height: Ycn.px(119)),
            Container(
              width: Ycn.px(480),
              height: Ycn.px(88),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Ycn.px(88)),
                border: Border.all(width: Ycn.px(2), color: Theme.of(context).accentColor),
              ),
              child: FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(80))),
                child: Text('我知道了', style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(34))),
              ),
            ),
            Expanded(child: Container())
          ],
        ),
      ),
    );
  }
}
