import '../../apis/user.dart';
import '../../common/Ycn.dart';
import '../../common/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../provider/ProviderUserInfo.dart';

class PageAuthIdentity extends StatefulWidget {
  PageAuthIdentity({Key key}) : super(key: key);

  @override
  _PageAuthIdentityState createState() => _PageAuthIdentityState();
}

class _PageAuthIdentityState extends State<PageAuthIdentity> {
  bool _loading = false;
  bool _requesting = false;
  ProviderUserInfo __userinfo;

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();

  // 收起键盘
  void _pulldownKB() {
    this._focusNode1.unfocus();
    this._focusNode2.unfocus();
    this._focusNode3.unfocus();
  }

  // 点击提交
  void _submit() {
    this._pulldownKB();
    if (this._textEditingController1.text.isEmpty) {
      Ycn.toast('微信昵称不能为空');
      return;
    }
    if (!RegExp(r'^[\u4E00-\u9FA5\uf900-\ufa2d·s]{2,20}$').hasMatch(this._textEditingController2.text)) {
      Ycn.toast('请输入正确的真实姓名');
      return;
    }
    if (!(this._textEditingController3.text.length == 0) &&
        !RegExp(r'^[1-9]\d{5}(18|19|20|(3\d))\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$')
            .hasMatch(this._textEditingController2.text)) {
      Ycn.toast('请输入正确的身份证号');
      return;
    }
    setState(() {
      this._loading = true;
    });
    if (!this._requesting) {
      this._requesting = true;
      apiSubmitAuth({
        'wechatname': this._textEditingController1.text,
        'realname': this._textEditingController2.text,
        'cre_num': this._textEditingController3.text,
      }).then((status) {
        this.__userinfo.upData({'cert_status': '1'});
        Navigator.of(context).pushNamedAndRemoveUntil('/auth-progress', (Route<dynamic> route) => false);
      }).whenComplete(() {
        setState(() {
          this._loading = false;
          this._requesting = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, ProviderUserInfo userinfo, Widget child) {
      this.__userinfo = userinfo;
      return Loading(
        loading: this._loading,
        child: Scaffold(
          appBar: Ycn.appBar(context, title: '身份认证', back: false),
          body: Column(
            children: <Widget>[
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('邀请人', style: TextStyle(fontSize: Ycn.px(32))),
                    Text(this.__userinfo.userinfo['recom_nickname'], style: TextStyle(fontSize: Ycn.px(26))),
                  ],
                ),
              ),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                margin: EdgeInsets.only(bottom: Ycn.px(20)),
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('联系方式', style: TextStyle(fontSize: Ycn.px(32))),
                    Text(this.__userinfo.userinfo['recom_mobile'], style: TextStyle(fontSize: Ycn.px(26))),
                  ],
                ),
              ),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('微信昵称', style: TextStyle(fontSize: Ycn.px(32), height: 1.25)),
                    SizedBox(
                      width: Ycn.px(43),
                    ),
                    Expanded(
                      child: TextField(
                        cursorWidth: Ycn.px(2),
                        focusNode: this._focusNode1,
                        keyboardType: TextInputType.text,
                        controller: _textEditingController1,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(fontSize: Ycn.px(26)),
                        cursorRadius: Radius.circular(Ycn.px(2)),
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                          hintText: '请填写微信昵称',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Theme.of(context).textTheme.display1.color, height: 1),
                        ),
                        inputFormatters: [LengthLimitingTextInputFormatter(16)],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('真实姓名', style: TextStyle(fontSize: Ycn.px(32), height: 1.25)),
                    SizedBox(
                      width: Ycn.px(43),
                    ),
                    Expanded(
                      child: TextField(
                        cursorWidth: Ycn.px(2),
                        focusNode: this._focusNode2,
                        keyboardType: TextInputType.text,
                        controller: _textEditingController2,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(fontSize: Ycn.px(26)),
                        cursorRadius: Radius.circular(Ycn.px(2)),
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                          hintText: '请填写真实姓名',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Theme.of(context).textTheme.display1.color, height: 1),
                        ),
                        inputFormatters: [LengthLimitingTextInputFormatter(29)],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('身份证号', style: TextStyle(fontSize: Ycn.px(32), height: 1.25)),
                    SizedBox(
                      width: Ycn.px(43),
                    ),
                    Expanded(
                      child: TextField(
                        cursorWidth: Ycn.px(2),
                        focusNode: this._focusNode3,
                        keyboardType: TextInputType.text,
                        controller: _textEditingController3,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(fontSize: Ycn.px(26)),
                        cursorRadius: Radius.circular(Ycn.px(2)),
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                          hintText: '请填写身份证号(选填）',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Theme.of(context).textTheme.display1.color, height: 1),
                        ),
                        inputFormatters: [LengthLimitingTextInputFormatter(29)],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: Ycn.px(630),
                height: Ycn.px(88),
                margin: EdgeInsets.only(top: Ycn.px(51)),
                child: FlatButton(
                  onPressed: this._submit,
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(88))),
                  child: Text('提交', style: TextStyle(fontSize: Ycn.px(34), color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
