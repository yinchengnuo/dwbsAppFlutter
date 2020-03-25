import 'package:dwbs_app_flutter/common/components.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dwbs_app_flutter/provider/ProviderComm.dart';
import 'package:dwbs_app_flutter/pages/PageHome/TabComm/components/CommListItemTop.dart';
import 'package:dwbs_app_flutter/pages/PageHome/TabComm/components/CommListItemBottom.dart';

class PageArticleDetail extends StatefulWidget {
  PageArticleDetail({Key key}) : super(key: key);

  @override
  _PageArticleDetailState createState() => _PageArticleDetailState();
}

class _PageArticleDetailState extends State<PageArticleDetail> {
  bool _loading = false;
  ProviderComm __comm;

  @override
  Widget build(BuildContext context) {
    final type = (ModalRoute.of(context).settings.arguments as Map)['type'];
    final index = (ModalRoute.of(context).settings.arguments as Map)['index'];
    return Consumer(builder: (BuildContext context, ProviderComm comm, Widget child) {
      this.__comm = comm;
      return Loading(
        loading: this._loading,
        child: Scaffold(
          appBar: Ycn.appBar(context, title: '文章详情'),
          body: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: Ycn.px(30), vertical: Ycn.px(25)),
                  color: Colors.white,
                  child: CommListItemTop(
                    data: type == -1 ? this.__comm.indexArticle : this.__comm.commList[type][index],
                  )),
              Expanded(
                child: WebView(
                  // initialUrl: type == -1 ? this.__comm.indexArticle['id'] : this.__comm.commList[type][index]['id'],
                  initialUrl: 'https://mp.weixin.qq.com/s/_tnkaY76-qUU-eQTziNqDQ',
                  onPageFinished: (e) => setState(() => this._loading = false),
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
              SizedBox(height: Ycn.px(1)),
              CommListItemBottom(
                data: type == -1 ? this.__comm.indexArticle : this.__comm.commList[type][index],
                type: type,
                index: index,
                provider: this.__comm,
              )
            ],
          ),
        ),
      );
    });
  }
}
