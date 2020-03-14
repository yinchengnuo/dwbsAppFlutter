import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';

class IndexBottomArtilce extends StatelessWidget {
  final articleInfo;
  const IndexBottomArtilce({Key key, this.articleInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(346),
      margin: EdgeInsets.only(bottom: Ycn.px(12)),
      child: Column(
        children: <Widget>[
          Container(
              height: Ycn.px(72),
              color: Colors.white,
              padding: EdgeInsets.only(left: Ycn.px(30)),
              child: Row(
                children: <Widget>[
                  Container(
                    width: Ycn.px(6),
                    height: Ycn.px(30),
                    color: Theme.of(context).accentColor,
                    margin: EdgeInsets.only(right: Ycn.px(16)),
                  ),
                  Text('常来微聊', style: TextStyle(fontSize: Ycn.px(32)))
                ],
              )),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, Ycn.px(1), 0, Ycn.px(1)),
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    print('点击了首页文章');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: Ycn.px(30)),
                      Container(
                        width: Ycn.px(180),
                        height: Ycn.px(180),
                        margin: EdgeInsets.only(right: Ycn.px(35)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Ycn.px(12)),
                          child: Image.network(articleInfo['imgurl'][0]),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: Ycn.px(180),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  articleInfo['title'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(height: 1.25, fontSize: Ycn.px(32)),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '        ' + articleInfo['summary'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(height: 1.25, fontSize: Ycn.px(24)),
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '${Ycn.formatTime(articleInfo['created_at'])}',
                                      style: TextStyle(color: Theme.of(context).textTheme.display1.color, fontSize: Ycn.px(24)),
                                    ),
                                    Text(
                                      '发布人: ' + articleInfo['author'],
                                      style: TextStyle(color: Theme.of(context).textTheme.display1.color, fontSize: Ycn.px(24)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: Ycn.px(30)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: Ycn.px(72),
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  print('点击了显示更多');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text('显示更多', style: TextStyle(fontSize: Ycn.px(26))), Icon(Icons.arrow_forward_ios, size: Ycn.px(26))],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
