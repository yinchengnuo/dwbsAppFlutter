import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dwbs_app_flutter/common/PAGEPreviewImage/PAGEPreviewImage.dart';
import '../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dwbs_app_flutter/apis/user.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class PageAuthCard extends StatefulWidget {
  PageAuthCard({Key key}) : super(key: key);

  @override
  _PageAuthCardState createState() => _PageAuthCardState();
}

class _PageAuthCardState extends State<PageAuthCard> with SingleTickerProviderStateMixin {
  Map _data;
  bool _loading = false; // loading

  // 保存图片到本地
  void _saveImg() {
    setState(() {
      this._loading = true;
    });
    Dio().get(this._data['url'], options: Options(responseType: ResponseType.bytes)).then((res) {
      ImageGallerySaver.saveImage(Uint8List.fromList(res.data)).then((res) {
        Ycn.toast('保存成功');
      }).catchError((e) {
        Ycn.toast('保存失败，请检查是否为大卫博士开启写入存储权限');
      });
    }).whenComplete(() {
      setState(() {
        this._loading = false;
      });
    });
  }

  // 获取授权书信息
  void getAuthCard(id) {
    apiGetAuthCard({'id': id}).then((status) {
      setState(() {
        this._data = status.data['data'];
      });
    }).whenComplete(() {
      setState(() {
        this._loading = false;
      });
    });
  }

  // 点击预览图片
  void _previewImg() {
    Navigator.of(context).push(FadeRoute(
        page: PAGEPreviewImage(
      imageProvider: NetworkImage(this._data['url']),
      heroTag: 'simple',
    )));
  }

  @override
  Widget build(BuildContext context) {
    if (this._data == null) {
      this.getAuthCard((ModalRoute.of(context).settings.arguments as Map)['id'].toString());
    }
    return Loading(
      loading: this._loading,
      child: Scaffold(
        appBar: Ycn.appBar(context, title: '授权证书'),
        body: this._data == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        height: Ycn.px(922),
                        color: Colors.white,
                        alignment: Alignment(0, 0),
                        child: GestureDetector(
                          onTap: this._previewImg,
                          child: Image.network(
                            this._data['url'],
                            width: Ycn.px(481),
                            height: Ycn.px(836),
                            fit: BoxFit.fill,
                          ),
                        )),
                    SizedBox(height: Ycn.px(88)),
                    Container(
                      height: Ycn.px(88),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Ycn.px(10)),
                            child: Container(
                              width: Ycn.px(315),
                              color: Theme.of(context).accentColor,
                              child: MaterialInkWell(
                                onTap: this._saveImg,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.file_download, color: Colors.white, size: Ycn.px(37)),
                                    SizedBox(width: Ycn.px(9)),
                                    Text('保存图片', style: TextStyle(fontSize: Ycn.px(34), color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Ycn.px(10)),
                            child: Container(
                              width: Ycn.px(315),
                              color: Theme.of(context).accentColor,
                              child: MaterialInkWell(
                                onTap: () => Navigator.of(context).pushNamed('/camera'),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.card_travel, color: Colors.white, size: Ycn.px(37)),
                                    SizedBox(width: Ycn.px(9)),
                                    Text('分享证书', style: TextStyle(fontSize: Ycn.px(34), color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Ycn.px(88)),
                  ],
                ),
              ),
      ),
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
