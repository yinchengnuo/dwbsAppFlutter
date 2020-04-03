import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../common/Ycn.dart';
import '../../apis/user.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class PageMyUpdata extends StatefulWidget {
  PageMyUpdata({Key key}) : super(key: key);

  @override
  _PageMyUpdataState createState() => _PageMyUpdataState();
}

class _PageMyUpdataState extends State<PageMyUpdata> {
  bool _loading = false;
  List<Asset> images = [];
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();

  Future<void> loadAssets() async {
    // setState(() {
    //   images = List<Asset>();
    // });
    List<Asset> resultList;
    if ((await PermissionHandler().requestPermissions([PermissionGroup.storage]))[PermissionGroup.storage] == PermissionStatus.granted) {
      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 4 - this.images.length,
          materialOptions: MaterialOptions(
            actionBarTitle: "选择图片",
            allViewTitle: "选择图片",
            actionBarColor: "#333333",
            actionBarTitleColor: "#FFFFFF",
            statusBarColor: '#333333',
            startInAllView: true,
            lightStatusBar: false,
            selectCircleStrokeColor: "#333333",
            textOnNothingSelected: '还没有选择图片呢',
            selectionLimitReachedText: "可选图片最多为4张",
          ),
        );
      } catch (e) {}
      if (!mounted) return;
      setState(() {
        if (this.images.length == 0) {
          images = resultList;
        } else {
          images.addAll(resultList);
        }
      });
    } else {
      Ycn.toast('保存失败，请为大卫博士开启读取存储权限');
    }
  }

  // 上传图片
  void _submit() async {
    if (this._textEditingController1.text.isEmpty) {
      Ycn.toast('请输入付款金额');
      return;
    }
    if (this.images.length > 0) {
      setState(() {
        this._loading = true;
      });
      this._focusNode1.unfocus();
      this._focusNode2.unfocus();
      FormData formData = FormData();
      formData.fields.add(MapEntry("remark", this._textEditingController2.text));
      for (int i = 0; i < this.images.length; i++) {
        ByteData byteData = await this.images[i].getByteData();
        formData.files.add(
          MapEntry(
            "files",
            MultipartFile.fromBytes(
              await FlutterImageCompress.compressWithList(byteData.buffer.asUint8List(), quality: 10),
              filename: '${i + 1}.jpg',
              contentType: MediaType("image", "jpg"),
            ),
          ),
        );
      }
      apiProxyUpload(formData).then((status) {
        if (status.data['code'].toString() == '200') {
          Navigator.of(context).pop({});
        }
      }).whenComplete(() {
        setState(() {
          this._loading = false;
        });
      });
    } else {
      Ycn.toast('请选择付款截图');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: this._loading,
      child: Scaffold(
        appBar: Ycn.appBar(context, title: '我的升级'),
        body: Column(
          children: <Widget>[
            Container(
              height: Ycn.px(160),
              color: Colors.white,
              alignment: Alignment(0, 0),
              child: Container(
                width: Ycn.px(690),
                height: Ycn.px(90),
                padding: EdgeInsets.all(Ycn.px(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Ycn.px(10)),
                  border: Border.all(width: Ycn.px(1), color: Ycn.getColor('#E5E5E5')),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('付款金额：', style: TextStyle(fontSize: Ycn.px(26))),
                    Expanded(
                      child: TextField(
                        cursorWidth: Ycn.px(2),
                        focusNode: this._focusNode1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        controller: _textEditingController1,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor, height: 1),
                        cursorRadius: Radius.circular(Ycn.px(2)),
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                          hintText: '请输入付款金额',
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: Ycn.px(26), height: 0.9, color: Theme.of(context).textTheme.display1.color),
                        ),
                        inputFormatters: [LengthLimitingTextInputFormatter(6), WhitelistingTextInputFormatter.digitsOnly],
                      ),
                    ),
                    SizedBox(width: Ycn.px(8)),
                    Text('元', style: TextStyle(fontSize: Ycn.px(26)))
                  ],
                ),
              ),
            ),
            SizedBox(height: Ycn.px(10)),
            Container(
              color: Colors.white,
              height: Ycn.px(200),
              child: Row(
                children: <Widget>[
                  ...this.images.map((item) {
                    return InkWell(
                      onTap: () async {
                        ByteData byteData = await item.getByteData();
                        Navigator.of(context).push(FadeRoute(
                          page: PreviewImage(
                            imageProvider: MemoryImage(byteData.buffer.asUint8List()),
                            heroTag: 'simple',
                          ),
                        ));
                      },
                      child: Container(
                        width: Ycn.px(150),
                        height: Ycn.px(150),
                        margin: EdgeInsets.only(left: Ycn.px(30)),
                        child: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            AssetThumb(
                              asset: item,
                              width: Ycn.px(150).floor(),
                              height: Ycn.px(150).floor(),
                            ),
                            Positioned(
                              width: Ycn.px(30),
                              height: Ycn.px(30),
                              top: Ycn.px(0),
                              right: Ycn.px(0),
                              child: InkWell(
                                onTap: () {
                                  Ycn.modal(context, content: ['确定删除这张图片？']).then((res) {
                                    if (res != null) {
                                      setState(() {
                                        this.images.removeAt(this.images.indexOf(item));
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment(0, 0),
                                  color: Colors.black.withOpacity(0.3),
                                  child: Icon(Icons.close, size: Ycn.px(30), color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  this.images.length != 4
                      ? Container(
                          width: Ycn.px(150),
                          height: Ycn.px(150),
                          margin: EdgeInsets.only(left: Ycn.px(30)),
                          decoration: BoxDecoration(border: Border.all(width: Ycn.px(1), color: Ycn.getColor('#999999'))),
                          child: MaterialInkWell(
                            onTap: this.loadAssets,
                            child: Center(
                              child: Text(
                                '+',
                                style: TextStyle(fontSize: Ycn.px(64), fontWeight: FontWeight.w300, color: Ycn.getColor('#999999')),
                              ),
                            ),
                          ),
                        )
                      : Container(width: 0, height: 0),
                ],
              ),
            ),
            SizedBox(height: Ycn.px(1)),
            Container(
              color: Colors.white,
              height: Ycn.px(160),
              alignment: Alignment(0, 0),
              child: Container(
                width: Ycn.px(690),
                height: Ycn.px(120),
                padding: EdgeInsets.all(Ycn.px(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Ycn.px(10)),
                  border: Border.all(width: Ycn.px(1), color: Ycn.getColor('#E5E5E5')),
                ),
                child: TextField(
                  cursorWidth: Ycn.px(2),
                  focusNode: this._focusNode2,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.left,
                  maxLength: 20,
                  controller: _textEditingController2,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: Ycn.px(26), height: 1),
                  cursorRadius: Radius.circular(Ycn.px(2)),
                  cursorColor: Theme.of(context).accentColor,
                  decoration: InputDecoration(
                    hintText: '可添加备注：最多20个字',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: Ycn.px(26), height: 0.9, color: Theme.of(context).textTheme.display1.color),
                  ),
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                ),
              ),
            ),
            Container(
              height: Ycn.px(88),
              width: Ycn.px(480),
              margin: EdgeInsets.symmetric(vertical: Ycn.px(98)),
              child: FlatButton(
                onPressed: this._submit,
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(88))),
                child: Text('提交凭证', style: TextStyle(color: Colors.white, fontSize: Ycn.px(34))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
