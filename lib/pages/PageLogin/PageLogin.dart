import 'package:flutter/services.dart';

import '../../common/Ycn.dart';
import '../../common/components.dart';
import 'package:flutter/material.dart';

class PageLogin extends StatefulWidget {
  PageLogin({Key key}) : super(key: key);

  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool _loading = false;
  bool _isReg = false;
  int _count = 0;

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();

  // 点击获取验证码
  void _getCode() {
    if (this._textEditingController1.text.length > 4) {
      this._focusNode1.unfocus();
      this._focusNode2.unfocus();
      this._focusNode3.unfocus();
      this._loading = true;
      setState(() {});
    } else {
      Ycn.toast('手机号格式不正确');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white),
      child: Loading(
        loading: this._loading,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(Ycn.px(168) - Ycn.mediaQuery.padding.top),
            child: AppBar(title: Text(''), elevation: 0, automaticallyImplyLeading: false),
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: Ycn.screenH() - Ycn.px(168)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(60)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset('lib/images/public/login.png', width: Ycn.px(345), height: Ycn.px(126)),
                        SizedBox(height: Ycn.px(63)),
                        Container(
                          height: Ycn.px(92),
                          margin: EdgeInsets.only(top: Ycn.px(21)),
                          child: MaterialInkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('选择国家/地区', style: TextStyle(fontSize: Ycn.px(32))),
                                    SizedBox(width: Ycn.px(24)),
                                    Text('中国大陆(+86)', style: TextStyle(color: Theme.of(context).accentColor)),
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
                                  style: TextStyle(fontSize: Ycn.px(26)),
                                  cursorRadius: Radius.circular(Ycn.px(2)),
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                    hintText: '请输入手机号',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Theme.of(context).textTheme.display1.color),
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
                                  style: TextStyle(fontSize: Ycn.px(26)),
                                  cursorRadius: Radius.circular(Ycn.px(2)),
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                    hintText: '请输入验证码',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Theme.of(context).textTheme.display1.color),
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
                                      child: Text(this._count > 0 ? '获取验证码 ( ${this._count} )' : '获取验证码',
                                          style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).accentColor))),
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
                                  focusNode: this._focusNode3,
                                  keyboardType: TextInputType.text,
                                  controller: _textEditingController3,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(fontSize: Ycn.px(26)),
                                  cursorRadius: Radius.circular(Ycn.px(2)),
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                    hintText: '请输入邀请码',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Theme.of(context).textTheme.display1.color),
                                  ),
                                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: Ycn.px(1), color: Theme.of(context).textTheme.body1.color),
                        Container(
                          height: Ycn.px(80),
                          margin: EdgeInsets.fromLTRB(Ycn.px(0), Ycn.px(51), Ycn.px(0), Ycn.px(40)),
                          width: double.infinity,
                          child: FlatButton(
                            onPressed: () {},
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(80))),
                            child: Text('立即登录', style: TextStyle(color: Colors.white, fontSize: Ycn.px(34))),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.check_box, size: Ycn.px(24), color: Theme.of(context).accentColor),
                            SizedBox(width: Ycn.px(8)),
                            Text('我已阅读并同意', style: TextStyle(fontSize: Ycn.px(22), height: 1.2)),
                            Text('《大卫博士会员隐私协议》', style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(22), height: 1.2)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: Ycn.px(56)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(width: Ycn.px(240), height: Ycn.px(1), color: Ycn.getColor('#B2B2B2')),
                            Text('第三方登录', style: TextStyle(fontSize: Ycn.px(22), color: Ycn.getColor('#B2B2B2'))),
                            Container(width: Ycn.px(240), height: Ycn.px(1), color: Ycn.getColor('#B2B2B2')),
                          ],
                        ),
                        SizedBox(height: Ycn.px(39)),
                        Container(
                          width: Ycn.px(88),
                          height: Ycn.px(88),
                          alignment: Alignment(0, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Ycn.px(44)),
                            border: Border.all(width: Ycn.px(2), color: Ycn.getColor('#64AB23')),
                          ),
                          child: Image.asset('lib/images/public/wx-login.png', width: Ycn.px(45), height: Ycn.px(45)),
                        ),
                        SizedBox(height: Ycn.px(32) + Ycn.mediaQuery.padding.bottom)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
