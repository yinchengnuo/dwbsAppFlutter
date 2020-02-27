import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';

class CommListItemBottom extends StatelessWidget {
  final data, type, index, provider;
  const CommListItemBottom({Key key, this.data, this.type, this.index, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
              height: Ycn.px(90),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => this.provider.thumb(this.type, this.index),
                        child: Container(
                          height: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              data['like']
                                  ? ImageIcon(AssetImage('lib/images/public/like-fill.png'),
                                      color: Theme.of(context).accentColor, size: Ycn.px(38))
                                  : ImageIcon(
                                      AssetImage('lib/images/public/like.png'),
                                      color: Theme.of(context).textTheme.body2.color,
                                      size: Ycn.px(38),
                                    ),
                              SizedBox(width: Ycn.px(10)),
                              Text('点赞', style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).textTheme.body2.color)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(width: Ycn.px(1), height: Ycn.px(40), color: Theme.of(context).scaffoldBackgroundColor),
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => this.provider.collection(this.type, this.index),
                        child: Container(
                          height: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              data['collection']
                                  ? ImageIcon(AssetImage('lib/images/public/heart-fill.png'),
                                      color: Theme.of(context).accentColor, size: Ycn.px(38))
                                  : ImageIcon(
                                      AssetImage('lib/images/public/heart.png'),
                                      color: Theme.of(context).textTheme.body2.color,
                                      size: Ycn.px(38),
                                    ),
                              SizedBox(width: Ycn.px(10)),
                              Text('收藏', style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).textTheme.body2.color)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(width: Ycn.px(1), height: Ycn.px(40), color: Theme.of(context).scaffoldBackgroundColor),
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => print('点击了分享'),
                        child: Container(
                          height: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ImageIcon(
                                AssetImage('lib/images/public/share.png'),
                                color: Theme.of(context).textTheme.body2.color,
                                size: Ycn.px(38),
                              ),
                              SizedBox(width: Ycn.px(10)),
                              Text('分享', style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).textTheme.body2.color)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
  }
}