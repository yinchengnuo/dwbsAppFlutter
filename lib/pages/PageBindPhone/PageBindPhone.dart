import 'dart:async';

import 'package:dwbs_app_flutter/apis/auth.dart';
import 'package:dwbs_app_flutter/common/Storage.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import 'package:flutter/services.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageBindPhone extends StatefulWidget {
  PageBindPhone({Key key}) : super(key: key);

  @override
  _PageBindPhoneState createState() => _PageBindPhoneState();
}

class _PageBindPhoneState extends State<PageBindPhone> {
  Map _wx = Map(); // openid
  int _count = 0; // 倒计时数字
  int _maxCount = 120; // 倒计时长
  String _area = '中国大陆'; // 地区
  String _code = '86'; // 手机号默认地区
  bool _isReg = false; // 是否是注册
  bool _loading = false; // loading
  bool _requesting = false; // 防止连点

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

  // 点击选择国家地区
  void _choosePhoneArea() {
    Navigator.of(context).pushNamed('/phone-area').then((popData) {
      final res = popData as Map;
      if (res != null) {
        setState(() {
          this._area = res['area'];
          this._code = res['code'].toString();
        });
      }
    });
  }

  // 点击获取验证码
  void _getCode() {
    if (!(this._textEditingController1.text.length < 5)) {
      this._pulldownKB();
      if (this._count == 0) {
        if (!this._requesting) {
          setState(() {
            this._loading = true;
            this._requesting = true;
          });
          apiGetPhoneCode({'mobile': this._textEditingController1.text, 'code': this._code}).then((status) {
            final res = status.data;
            if (res['code'] == 200) {
              setState(() {
                this._count = this._maxCount;
                this._isReg = num.parse(res['data']['status'].toString()) == 0 ? false : true;
              });
              Timer.periodic(Duration(seconds: 1), (timer) {
                setState(() {
                  this._count--;
                  if (this._count == 0) {
                    timer.cancel();
                  }
                });
              });
            } else {
              Ycn.toast(res['message']);
            }
          }).whenComplete(() {
            setState(() {
              this._loading = false;
              this._requesting = false;
            });
          });
        }
      } else {
        Ycn.toast('验证码已发送，请稍后重试');
      }
    } else {
      Ycn.toast('手机号格式不正确');
    }
  }

  // 点击立即登录/注册
  void _login() {
    this._pulldownKB();
    if (this._textEditingController1.text.length < 5) {
      Ycn.toast('手机号格式不正确');
      return;
    }
    if (this._textEditingController2.text.length != 6) {
      Ycn.toast('验证码格式不正确');
      return;
    }
    if (this._isReg && this._textEditingController3.text.length != 6) {
      Ycn.toast('邀请码格式不正确');
      return;
    }
    if (this._isReg) {
      if (!this._requesting) {
        setState(() {
          this._loading = true;
          this._requesting = true;
        });
        apiReg({
          'code': this._code,
          'mobile': this._textEditingController1.text,
          'verify_code': this._textEditingController2.text,
          'recom_code': this._textEditingController3.text,
          'openid': this._wx['openid'],
          'access_token': this._wx['access_token'],
        }).then((status) async {
          final res = status.data;
          await Storage.setter('token', res['data']['token']);
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        }).whenComplete(() {
          setState(() {
            this._loading = false;
            this._requesting = false;
          });
        });
      }
    } else {
      if (!this._requesting) {
        setState(() {
          this._loading = true;
          this._requesting = true;
        });
        apiLoginByCode({
          'code': this._code,
          'mobile': this._textEditingController1.text,
          'verify_code': this._textEditingController2.text,
          'openid': this._wx['openid'],
          'access_token': this._wx['access_token'],
        }).then((status) async {
          final res = status.data;
          await Storage.setter('token', res['data']['token']);
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        }).whenComplete(() {
          setState(() {
            this._loading = false;
            this._requesting = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    this._wx = ModalRoute.of(context).settings.arguments as Map;
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white),
      child: Loading(
        loading: this._loading,
        child: Scaffold(
          appBar: Ycn.appBar(context, title: '手机绑定'),
          body: Container(
            padding: EdgeInsets.all(Ycn.px(60)),
            child: Column(
              children: <Widget>[
                Container(
                  height: Ycn.px(92),
                  margin: EdgeInsets.only(top: Ycn.px(21)),
                  child: MaterialInkWell(
                    onTap: this._choosePhoneArea,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('选择国家/地区', style: TextStyle(fontSize: Ycn.px(32))),
                            SizedBox(width: Ycn.px(24)),
                            Text('${this._area}(+${this._code})', style: TextStyle(color: Theme.of(context).accentColor)),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios, size: Ycn.px(32), color: Theme.of(context).textTheme.body2.color),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: Ycn.px(92),
                  margin: EdgeInsets.only(top: Ycn.px(21)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: Ycn.px(15)),
                      Icon(Icons.phone_android, size: Ycn.px(42), color: Theme.of(context).textTheme.display1.color),
                      SizedBox(width: Ycn.px(15)),
                      Expanded(
                        child: TextField(
                          cursorWidth: Ycn.px(2),
                          focusNode: this._focusNode1,
                          keyboardType: TextInputType.number,
                          controller: _textEditingController1,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(fontSize: Ycn.px(34)),
                          cursorRadius: Radius.circular(Ycn.px(2)),
                          cursorColor: Theme.of(context).accentColor,
                          decoration: InputDecoration(
                            hintText: '请输入手机号',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                          ),
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: Ycn.px(1), color: Theme.of(context).textTheme.body1.color),
                Container(
                  height: Ycn.px(92),
                  margin: EdgeInsets.only(top: Ycn.px(21)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: Ycn.px(15)),
                      Icon(Icons.email, size: Ycn.px(42), color: Theme.of(context).textTheme.display1.color),
                      SizedBox(width: Ycn.px(15)),
                      Expanded(
                        child: TextField(
                          cursorWidth: Ycn.px(2),
                          focusNode: this._focusNode2,
                          keyboardType: TextInputType.number,
                          controller: _textEditingController2,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(fontSize: Ycn.px(34)),
                          cursorRadius: Radius.circular(Ycn.px(2)),
                          cursorColor: Theme.of(context).accentColor,
                          decoration: InputDecoration(
                            hintText: '请输入验证码',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                          ),
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: Ycn.px(156)),
                        child: Container(
                          height: Ycn.px(46),
                          child: FlatButton(
                            color: Ycn.getColor('#FFEFF0'),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(46))),
                            padding: EdgeInsets.symmetric(horizontal: Ycn.px(24)),
                            onPressed: this._getCode,
                            child: Text(
                              this._count > 0 ? '获取验证码 ( ${this._count} )' : '获取验证码',
                              style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).accentColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: Ycn.px(1), color: Theme.of(context).textTheme.body1.color),
                this._isReg
                    ? Container(
                        height: Ycn.px(92),
                        margin: EdgeInsets.only(top: Ycn.px(21)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: Ycn.px(15)),
                            Icon(Icons.email, size: Ycn.px(42), color: Theme.of(context).textTheme.display1.color),
                            SizedBox(width: Ycn.px(15)),
                            Expanded(
                              child: TextField(
                                cursorWidth: Ycn.px(2),
                                focusNode: this._focusNode3,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _textEditingController3,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(fontSize: Ycn.px(34)),
                                cursorRadius: Radius.circular(Ycn.px(2)),
                                cursorColor: Theme.of(context).accentColor,
                                decoration: InputDecoration(
                                  hintText: '请输入邀请码',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                                ),
                                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(width: 0, height: 0),
                this._isReg ? Divider(height: Ycn.px(1), color: Theme.of(context).textTheme.body1.color) : Container(width: 0, height: 0),
                Container(
                  height: Ycn.px(80),
                  margin: EdgeInsets.fromLTRB(Ycn.px(0), Ycn.px(51), Ycn.px(0), Ycn.px(40)),
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: this._login,
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(80))),
                    child: Text('立即绑定', style: TextStyle(color: Colors.white, fontSize: Ycn.px(34))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.check_box, size: Ycn.px(24), color: Theme.of(context).accentColor),
                    SizedBox(width: Ycn.px(8)),
                    Text('我已阅读并同意', style: TextStyle(fontSize: Ycn.px(22), height: 1.2)),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pushNamed('/app-rules'),
                      padding: EdgeInsets.all(0),
                      child: Text(
                        '《大卫博士会员隐私协议》',
                        style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(22), height: 1.2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
