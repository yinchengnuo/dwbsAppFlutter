import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart'; // 引入工具库
import 'CommListItemTop.dart';
import 'CommListItemBottom.dart';

class CommListItem extends StatelessWidget {
  final data, type, index, provider;
  const CommListItem({Key key, this.data, this.type, this.index, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data['type'] == 0) {
      return Container(
        margin: EdgeInsets.only(top: Ycn.px(10)),
        child: Column(
          children: <Widget>[
            Container(
              height: Ycn.px(440),
              margin: EdgeInsets.only(bottom: Ycn.px(1)),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(Ycn.px(30), Ycn.px(25), Ycn.px(30), Ycn.px(19)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CommListItemTop(data: data),
                        Text(data['title'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Ycn.px(32))),
                        Text(data['summary'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Ycn.px(26), height: 1.5)),
                        Container(
                          height: Ycn.px(150),
                          child: Row(
                            children: <Widget>[
                              ...this
                                  .data['imgurl']
                                  .map((item) => data['imgurl'].indexOf(item) < 3
                                      ? Container(
                                          width: Ycn.px(222),
                                          margin: EdgeInsets.only(right: data['imgurl'].indexOf(item) == 2 ? 0 : Ycn.px(12)),
                                          decoration: ShapeDecoration(
                                            image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(item)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(10))),
                                            shadows: [BoxShadow(blurRadius: Ycn.px(1), color: Theme.of(context).textTheme.display1.color)],
                                          ),
                                        )
                                      : Container(width: 0, height: 0))
                                  .toList()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pushNamed('/article-detail', arguments: {
                        'type': this.type,
                        'index': this.index,
                      }),
                    ),
                  ),
                ],
              ),
            ),
            CommListItemBottom(data: data, type: type, index: index, provider: provider)
          ],
        ),
      );
    } else if (data['type'] == 1) {
      return Container(
        margin: EdgeInsets.only(top: Ycn.px(10)),
        child: Column(
          children: <Widget>[
            Container(
              height: Ycn.px(570),
              margin: EdgeInsets.only(bottom: Ycn.px(1)),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(Ycn.px(30), Ycn.px(25), Ycn.px(30), Ycn.px(19)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CommListItemTop(data: data),
                        Text(data['summary'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Ycn.px(26))),
                        Container(
                          height: Ycn.px(340),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Container(
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(10))),
                                  image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data['imgurl'][0])),
                                  shadows: [BoxShadow(blurRadius: Ycn.px(1), color: Theme.of(context).textTheme.display1.color)],
                                ),
                              ),
                              Center(
                                child: Icon(Icons.play_circle_outline, color: Colors.white, size: Ycn.px(138)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pushNamed('/article-detail', arguments: {
                        'type': this.type,
                        'index': this.index,
                      }),
                    ),
                  )
                ],
              ),
            ),
            CommListItemBottom(data: data, type: type, index: index, provider: provider)
          ],
        ),
      );
    } else if (data['type'] == 2) {
      final formatTime = Ycn.formatTime(data['created_at'], array: true);
      return Container(
        height: Ycn.px(422),
        margin: EdgeInsets.only(top: Ycn.px(10)),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: Ycn.px(60),
                    color: Colors.white,
                    alignment: Alignment(0, 0),
                    padding: EdgeInsets.fromLTRB(Ycn.px(30), 0, Ycn.px(30), 0),
                    child: Text(
                      data['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: Ycn.px(28)),
                    ),
                  ),
                  Container(
                    height: Ycn.px(300),
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(Ycn.px(30), Ycn.px(10), Ycn.px(30), Ycn.px(10)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(10))),
                            image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data['imgurl'])),
                            shadows: [BoxShadow(blurRadius: Ycn.px(1), color: Theme.of(context).textTheme.display1.color)],
                          ),
                        ),
                        Container(
                          alignment: Alignment(0, 0),
                          child: Container(
                            width: Ycn.px(159),
                            height: Ycn.px(44),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                              borderRadius: BorderRadius.circular(Ycn.px(22)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.play_circle_outline, color: Theme.of(context).accentColor, size: Ycn.px(26)),
                                SizedBox(width: Ycn.px(7)),
                                Text('观看视频', style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(24)))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: Ycn.px(60),
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(Ycn.px(30), Ycn.px(0), Ycn.px(30), Ycn.px(0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.date_range, size: Ycn.px(32), color: Theme.of(context).accentColor),
                            SizedBox(width: Ycn.px(11)),
                            Text('开播时间：', style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor)),
                            Text(
                              '${formatTime[1]}月${formatTime[3]}日 ${formatTime[4]}:${formatTime[5]}',
                              style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('查看详情', style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.body1.color)),
                            Icon(Icons.arrow_forward_ios, size: Ycn.px(26), color: Theme.of(context).textTheme.body2.color)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(onTap: () {
                Navigator.of(context).pushNamed('/webview', arguments: {'url': this.data['url']});
              }),
            )
          ],
        ),
      );
    }
  }
}
