import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fluwx/fluwx.dart';
import 'package:share/share.dart';
import '../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dwbs_app_flutter/apis/team.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    Dio().get(this._data['url'], options: Options(responseType: ResponseType.bytes)).then((res) async {
      if ((await PermissionHandler().requestPermissions([PermissionGroup.storage]))[PermissionGroup.storage] == PermissionStatus.granted) {
        ImageGallerySaver.saveImage(Uint8List.fromList(res.data)).then((res) {
          Ycn.toast('保存成功 ${Uri.decodeFull(res)}');
        });
      } else {
        Ycn.toast('保存失败，请为大卫博士开启写入存储权限');
      }
    }).whenComplete(() {
      setState(() {
        this._loading = false;
      });
    });
  }

  // 分享证书
  void _share() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
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
                            onTap: () async {
                              if (await isWeChatInstalled()) {
                                Navigator.of(context).pop();
                                shareToWeChat(
                                  WeChatShareImageModel(
                                    scene: WeChatScene.SESSION,
                                    image: this._data['url'],
                                  ),
                                );
                              } else {
                                Ycn.toast('微信未安装');
                              }
                            },
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
                            onTap: () async {
                              if (await isWeChatInstalled()) {
                                Navigator.of(context).pop();
                                shareToWeChat(
                                  WeChatShareImageModel(
                                    scene: WeChatScene.TIMELINE,
                                    image: this._data['url'],
                                  ),
                                );
                              } else {
                                Ycn.toast('微信未安装');
                              }
                            },
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
                            onTap: () {
                              Navigator.of(context).pop();
                              Share.share(this._data['url'], subject: '授权证书');
                            },
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
        page: PreviewImage(
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
                        child: Container(
                          width: Ycn.px(481),
                          height: Ycn.px(836),
                          child: CachedNetworkImage(
                            imageUrl: this._data['url'],
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
                            ),
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
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
                                onTap: this._share,
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
