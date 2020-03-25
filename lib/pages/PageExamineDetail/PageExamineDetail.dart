import 'package:city_pickers/city_pickers.dart';
import 'package:dwbs_app_flutter/apis/team.dart';
import 'package:dwbs_app_flutter/common/EventBus.dart';
import 'package:flutter/services.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:dwbs_app_flutter/common/components.dart';

class PageExamineDetail extends StatefulWidget {
  PageExamineDetail({Key key}) : super(key: key);

  @override
  _PageExamineDetailState createState() => _PageExamineDetailState();
}

class _PageExamineDetailState extends State<PageExamineDetail> {
  Map _data;
  bool _loading = false;
  int _rejectIndex = -1;
  bool _rejecting = false;
  String _choosedLevelID = '';
  Map<String, String> _levelData = {
    '110000': '顶级代理',
    '110001': '特级代理',
    '110002': '皇冠代理',
  };
  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();
  List _rejectResson = ['微信昵称填写错误', '与线下沟通情况不符', '真实姓名填写错误'];

  // 选择等级
  void _chooseLevel() {
    CityPickers.showCityPicker(
      context: context,
      height: Ycn.px(567),
      itemExtent: Ycn.px(123),
      provincesData: this._levelData,
      showType: ShowType.p,
      barrierDismissible: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      confirmWidget: Container(child: Text('确定', style: TextStyle(fontSize: Ycn.px(38), color: Theme.of(context).accentColor))),
      cancelWidget: Container(child: Text('取消', style: TextStyle(fontSize: Ycn.px(38), color: Ycn.getColor('#AAAAAA')))),
    ).then((res) {
      if (res != null) {
        setState(() {
          this._choosedLevelID = res.provinceId;
        });
      }
    });
  }

  // 收起驳回原因选择
  void _close() {
    this._focusNode.unfocus();
    setState(() {
      this._rejecting = false;
    });
  }

  // 确定驳回审核
  void _reject() {
    if (this._rejectIndex == -1) {
      Ycn.toast('请选择驳回原因');
    } else if (this._rejectIndex == 3 && this._textEditingController.text.isEmpty) {
      Ycn.toast('请输入驳回原因');
    } else {
      Ycn.modal(context, content: ['确定要驳回注册申请？']).then((res) {
        if (res != null) {
          setState(() {
            this._close();
            this._loading = true;
          });
          apiExamine({
            'type': this._data['name'] == '我的邀请' ? 'invite' : 'up',
            'action': 'reject',
            'id': this._data['data']['id'],
            'level': '',
            'cause': this._rejectIndex == 3 ? this._textEditingController.text : this._rejectResson[this._rejectIndex],
          }).then((status) {
            setState(() {
              this._loading = false;
              Ycn.modal(context, content: ['驳回成功'], cancel: false, back: false).then((res) {
                this._data['name'] == '我的邀请'
                    ? EventBus().emit('INVITE_EXAMINE_REJECT', [
                        this._data['index'],
                        this._rejectIndex == 3 ? this._textEditingController.text : this._rejectResson[this._rejectIndex],
                      ])
                    : EventBus().emit('UP_EXAMINE_REJECT', [
                        this._data['index'],
                        this._rejectIndex == 3 ? this._textEditingController.text : this._rejectResson[this._rejectIndex],
                      ]);
                Navigator.of(context).pop();
              });
            });
          });
        }
      });
    }
  }

  // 点击通过审核
  void _tapPass() {
    if ((this._data['name'] == '我的邀请' && this._choosedLevelID.isNotEmpty) || (this._data['name'] == '我的下级')) {
      Ycn.modal(context, content: ['确定通过注册审核']).then((res) {
        if (res != null) {
          setState(() {
            this._loading = true;
          });
          apiExamine({
            'type': this._data['name'] == '我的邀请' ? 'invite' : 'up',
            'action': 'pass',
            'id': this._data['data']['id'],
            'level': this._levelData.keys.toList().indexOf(this._choosedLevelID),
            'cause': '',
          }).then((status) {
            setState(() {
              this._loading = false;
              Ycn.modal(context, content: ['通过成功'], cancel: false, back: false).then((res) {
                this._data['name'] == '我的邀请'
                    ? EventBus().emit('INVITE_EXAMINE_PASS', this._data['index'])
                    : EventBus().emit('UP_EXAMINE_PASS', this._data['index']);
                Navigator.of(context).pop();
              });
            });
          });
        }
      });
    } else {
      Ycn.toast('请选择代理级别');
    }
  }

  // 确定通过审核
  void _pass() {}

  @override
  Widget build(BuildContext context) {
    if (this._data == null) {
      this._data = (ModalRoute.of(context).settings.arguments as Map);
    }
    return WillPopScope(
      onWillPop: () async {
        if (this._rejecting) {
          this._close();
          return false;
        } else {
          return true;
        }
      },
      child: Loading(
        loading: this._loading,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Scaffold(
                appBar: Ycn.appBar(context, title: '审核详情'),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: Ycn.px(180),
                        color: Colors.white,
                        width: double.infinity,
                        padding: EdgeInsets.all(Ycn.px(30)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('申请人：${this._data['data']['apply_name']}',
                                maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Ycn.px(32))),
                            Row(
                              children: <Widget>[
                                Icon(Icons.event_note, size: Ycn.px(30), color: Theme.of(context).accentColor),
                                SizedBox(width: Ycn.px(26)),
                                Text(
                                  '邀请人：${this._data['data']['invite_name']}',
                                  style: TextStyle(height: 1.25, fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.query_builder, size: Ycn.px(30), color: Theme.of(context).accentColor),
                                SizedBox(width: Ycn.px(26)),
                                Text(
                                  '申请时间：${this._data['data']['apply_time']}',
                                  style: TextStyle(height: 1.25, fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Ycn.px(1)),
                      Container(
                        height: Ycn.px(90),
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text('状态：', style: TextStyle(fontSize: Ycn.px(32))),
                                      Text(
                                        '${this._data['status']}',
                                        style: TextStyle(
                                          color: this._data['status'] == '待审核'
                                              ? Theme.of(context).accentColor
                                              : Theme.of(context).textTheme.display1.color,
                                          fontSize: Ycn.px(32),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Ycn.px(10)),
                      Container(
                        height: Ycn.px(90),
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('微信昵称', style: TextStyle(fontSize: Ycn.px(32))),
                            SizedBox(width: Ycn.px(30)),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${this._data['data']['apply_name']}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: Ycn.px(26)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: Ycn.px(1)),
                      Container(
                        height: Ycn.px(90),
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('真实姓名', style: TextStyle(fontSize: Ycn.px(32))),
                            SizedBox(width: Ycn.px(30)),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${this._data['data']['real_name']}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: Ycn.px(26)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: Ycn.px(1)),
                      Container(
                        height: Ycn.px(90),
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('身份证号', style: TextStyle(fontSize: Ycn.px(32))),
                            SizedBox(width: Ycn.px(30)),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${this._data['data']['id_card_num']}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: Ycn.px(26)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: Ycn.px(1)),
                      Container(
                        height: Ycn.px(90),
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('手机号 ', style: TextStyle(fontSize: Ycn.px(32))),
                            SizedBox(width: Ycn.px(30)),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${this._data['data']['apply_phone']}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: Ycn.px(26)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: Ycn.px(1)),
                      Container(
                        height: Ycn.px(90),
                        color: Colors.white,
                        child: MaterialInkWell(
                          padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                          onTap: this._data['name'] == '我的邀请' ? this._chooseLevel : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: this._data['name'] == '我的邀请'
                                ? <Widget>[
                                    Text('代理级别', style: TextStyle(fontSize: Ycn.px(32))),
                                    this._data['name'] == '我的邀请'
                                        ? Text(this._levelData[this._choosedLevelID] == null ? '请选择代理级别' : this._levelData[this._choosedLevelID],
                                            style: TextStyle(fontSize: Ycn.px(26)))
                                        : Text(this._data['data']['level'], style: TextStyle(fontSize: Ycn.px(26))),
                                    Icon(Icons.arrow_forward_ios, size: Ycn.px(30), color: Theme.of(context).textTheme.display1.color)
                                  ]
                                : <Widget>[
                                    Text('代理级别', style: TextStyle(fontSize: Ycn.px(32))),
                                    this._data['name'] == '我的邀请'
                                        ? Text(this._levelData[this._choosedLevelID] == null ? '请选择代理级别' : this._levelData[this._choosedLevelID],
                                            style: TextStyle(fontSize: Ycn.px(26)))
                                        : Text(this._data['data']['level'], style: TextStyle(fontSize: Ycn.px(26))),
                                  ],
                          ),
                        ),
                      ),
                      Container(
                        height: Ycn.px(88),
                        margin: EdgeInsets.symmetric(vertical: Ycn.px(99)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: Ycn.px(240),
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border.all(width: Ycn.px(2), color: Theme.of(context).accentColor),
                                  borderRadius: BorderRadius.circular(Ycn.px(10))),
                              child: FlatButton(
                                onPressed: () => setState(() => this._rejecting = true),
                                child: Text('驳回', style: TextStyle(fontSize: Ycn.px(32), color: Theme.of(context).accentColor)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(10))),
                              ),
                            ),
                            Container(
                              width: Ycn.px(240),
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(Ycn.px(10)),
                                border: Border.all(width: Ycn.px(2), color: Theme.of(context).accentColor),
                              ),
                              child: FlatButton(
                                onPressed: this._tapPass,
                                child: Text('通过', style: TextStyle(color: Colors.white, fontSize: Ycn.px(32))),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(10))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              this._rejecting
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      alignment: Alignment(0, 1),
                      child: Container(
                        height: Ycn.px(600),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(Ycn.px(10)))),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: Ycn.px(79),
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  Center(child: Text('驳回原因', style: TextStyle(fontSize: Ycn.px(32)))),
                                  Container(
                                    alignment: Alignment(1, 0),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: IconButton(icon: Icon(Icons.close), onPressed: this._close),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: Ycn.px(90),
                              alignment: Alignment(0, 0),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                              child: Text(
                                '若所邀请人填写信息与你线下沟通不符，请先进行联系确认之后，再进行驳回申请',
                                style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color, height: 1.5),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                                child: Column(
                                  children: <Widget>[
                                    ...this
                                        ._rejectResson
                                        .map((reason) => Column(
                                              children: <Widget>[
                                                Container(
                                                  height: Ycn.px(73),
                                                  child: MaterialInkWell(
                                                    onTap: () => setState(() => this._rejectIndex = this._rejectResson.indexOf(reason)),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Text(reason, style: TextStyle(fontSize: Ycn.px(26))),
                                                        this._rejectIndex == this._rejectResson.indexOf(reason)
                                                            ? Icon(Icons.check_circle, size: Ycn.px(30), color: Theme.of(context).accentColor)
                                                            : Icon(Icons.radio_button_unchecked,
                                                                size: Ycn.px(30), color: Theme.of(context).textTheme.display1.color),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(height: Ycn.px(1), color: Theme.of(context).scaffoldBackgroundColor),
                                              ],
                                            ))
                                        .toList(),
                                    Container(
                                      height: Ycn.px(73),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('其他原因'),
                                          SizedBox(width: Ycn.px(30)),
                                          Expanded(
                                            child: TextField(
                                              onTap: () => setState(() => this._rejectIndex = this._rejectResson.length),
                                              cursorWidth: Ycn.px(2),
                                              focusNode: this._focusNode,
                                              keyboardType: TextInputType.text,
                                              controller: _textEditingController,
                                              textInputAction: TextInputAction.done,
                                              style: TextStyle(fontSize: Ycn.px(26)),
                                              cursorRadius: Radius.circular(Ycn.px(2)),
                                              cursorColor: Theme.of(context).accentColor,
                                              decoration: InputDecoration(
                                                hintText: '请输入原因（长度不超过10字）',
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                                              ),
                                              inputFormatters: [LengthLimitingTextInputFormatter(10)],
                                            ),
                                          ),
                                          SizedBox(width: Ycn.px(30)),
                                          this._rejectIndex == this._rejectResson.length
                                              ? Icon(Icons.check_circle, size: Ycn.px(30), color: Theme.of(context).accentColor)
                                              : Icon(
                                                  Icons.radio_button_unchecked,
                                                  size: Ycn.px(30),
                                                  color: Theme.of(context).textTheme.display1.color,
                                                ),
                                        ],
                                      ),
                                    ),
                                    Container(height: Ycn.px(1), color: Theme.of(context).scaffoldBackgroundColor),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: Ycn.px(158),
                                          height: Ycn.px(68),
                                          decoration: BoxDecoration(
                                              border: Border.all(width: Ycn.px(2), color: Theme.of(context).accentColor),
                                              borderRadius: BorderRadius.circular(Ycn.px(68))),
                                          child: FlatButton(
                                            onPressed: this._close,
                                            padding: EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(68))),
                                            child: Text('暂不驳回', style: TextStyle(fontSize: Ycn.px(32), color: Theme.of(context).accentColor)),
                                          ),
                                        ),
                                        Container(
                                          width: Ycn.px(158),
                                          height: Ycn.px(68),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Ycn.px(68)),
                                            color: Theme.of(context).accentColor,
                                            border: Border.all(width: Ycn.px(2), color: Theme.of(context).accentColor),
                                          ),
                                          child: FlatButton(
                                            padding: EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(68))),
                                            onPressed: this._reject,
                                            child: Text('驳回申请', style: TextStyle(fontSize: Ycn.px(32), color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(width: 0, height: 0)
            ],
          ),
        ),
      ),
    );
  }
}
