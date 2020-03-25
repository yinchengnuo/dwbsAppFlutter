import 'package:share/share.dart';
import '../../../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:dwbs_app_flutter/common/components.dart';

class CommListItemBottom extends StatelessWidget {
  final data, type, index, provider;
  const CommListItemBottom({Key key, this.data, this.type, this.index, this.provider}) : super(key: key);

  // 点击分享
  void _share(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Ycn.px(24)))),
        builder: (BuildContext context) {
          return Container(
            height: Ycn.px(220),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: MaterialInkWell(
                            onTap: () => Ycn.toast('分享到微信好友'),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('lib/images/public/sharewx.png', width: Ycn.px(56), height: Ycn.px(56), fit: BoxFit.fill),
                                SizedBox(height: Ycn.px(27)),
                                Text('分享好友', style: TextStyle(fontSize: Ycn.px(26))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: MaterialInkWell(
                            onTap: () => Ycn.toast('分享到朋友圈'),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('lib/images/public/sharepyq.png', width: Ycn.px(56), height: Ycn.px(56), fit: BoxFit.fill),
                                SizedBox(height: Ycn.px(27)),
                                Text('分享朋友圈', style: TextStyle(fontSize: Ycn.px(26))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: MaterialInkWell(
                            onTap: () => this._shareMore(context),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.more_horiz, size: Ycn.px(56)),
                                SizedBox(height: Ycn.px(27)),
                                Text('更多', style: TextStyle(fontSize: Ycn.px(26))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
                Container(width: double.infinity, height: Ycn.px(1), color: Ycn.getColor('#B2B2B2')),
                Container(
                  height: Ycn.px(64),
                  child: MaterialInkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Center(child: Text('取消', style: TextStyle(fontSize: Ycn.px(26)))),
                  ),
                )
              ],
            ),
          );
        });
  }

  // 分享到更多
  _shareMore(context) {
    Navigator.of(context).pop();
    Share.share('https://baidu.com', subject: this.data['title']);
  }

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
                          ? ImageIcon(AssetImage('lib/images/public/like-fill.png'), color: Theme.of(context).accentColor, size: Ycn.px(38))
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
                          ? ImageIcon(AssetImage('lib/images/public/heart-fill.png'), color: Theme.of(context).accentColor, size: Ycn.px(38))
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
                onTap: () => this._share(context),
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
