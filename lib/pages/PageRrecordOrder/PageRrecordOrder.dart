import '../../common/Ycn.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:dwbs_app_flutter/apis/good.dart';
import 'package:dwbs_app_flutter/apis/forturn.dart';
import 'package:dwbs_app_flutter/common/components.dart';

class PageRrecordOrder extends StatefulWidget {
  PageRrecordOrder({Key key}) : super(key: key);

  @override
  _PageRrecordOrderState createState() => _PageRrecordOrderState();
}

class _PageRrecordOrderState extends State<PageRrecordOrder> {
  List _list;
  int _goodNum = 0;
  String _choosedID;
  Map _pickerID = Map();
  bool _loading = false;
  bool _requesting = false;
  FocusNode _focusNode = FocusNode();
  Map<String, String> _pickerData = Map();
  TextEditingController _textEditingController = TextEditingController();

  // 网路请求方法
  Future _request() async {
    final res = (await apiGoodList()).data;
    int startID = 110000;
    setState(() {
      this._list = res['data']['list'];
      this._list.forEach((goodItem) {
        goodItem['type_id'].forEach((typeID) {
          this._pickerData['${startID}'] = '${goodItem['name']}-${goodItem['type'][goodItem['type_id'].indexOf(typeID)]}';
          this._pickerID['${startID}'] = {'goodID': goodItem['id'], 'typeID': typeID};
          startID++;
        });
      });
    });
  }

  // 选择商品
  void _chooseGood() {
    this._focusNode.unfocus();
    CityPickers.showCityPicker(
      context: context,
      height: Ycn.px(567),
      itemExtent: Ycn.px(123),
      provincesData: _pickerData,
      showType: ShowType.p,
      barrierDismissible: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      confirmWidget: Container(child: Text('确定', style: TextStyle(fontSize: Ycn.px(38), color: Theme.of(context).accentColor))),
      cancelWidget: Container(child: Text('取消', style: TextStyle(fontSize: Ycn.px(38), color: Ycn.getColor('#AAAAAA')))),
    ).then((res) {
      if (res != null) {
        setState(() {
          this._choosedID = res.provinceId;
        });
      }
    });
  }

  // 点击录入订单
  void _submit() {
    this._focusNode.unfocus();
    if (this._choosedID == null) {
      Ycn.toast('请选择要录入的商品类型');
      return;
    }
    if (this._goodNum == 0) {
      Ycn.toast('请输入要要录入的商品数量');
      return;
    }
    if (this._textEditingController.text.isEmpty) {
      Ycn.toast('请输入要要录入的商品总计金额');
      return;
    }
    if (!this._requesting) {
      setState(() {
        this._loading = true;
        this._requesting = true;
      });
      apiRecordOrder({
        'id': this._pickerID[this._choosedID]['goodID'],
        'type_id': this._pickerID[this._choosedID]['typeID'],
        'num': this._goodNum,
        'total': this._textEditingController.text,
      }).then((status) {
        this._choosedID = null;
        this._goodNum = 0;
        this._textEditingController.text = '0';
        Ycn.toast('录单成功');
      }).whenComplete(() {
        setState(() {
          this._loading = false;
          this._requesting = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this._request(); // 请求数据
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: this._loading,
      child: Scaffold(
        appBar: Ycn.appBar(
          context,
          title: '零售录单',
          action: AppBarTextAction(text: '历史记录', onTap: () => Navigator.of(context).pushNamed('/record-record')),
        ),
        body: this._list == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Container(
                    height: Ycn.px(90),
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: Ycn.px(1)),
                    child: MaterialInkWell(
                      onTap: this._chooseGood,
                      padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('商品款式', style: TextStyle(fontSize: Ycn.px(26))),
                          this._pickerData[this._choosedID] == null
                              ? Text(
                                  '请选择要录入的商品',
                                  style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                                )
                              : Text(
                                  this._pickerData[this._choosedID],
                                  style: TextStyle(fontSize: Ycn.px(26)),
                                ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: Ycn.px(30),
                            color: Theme.of(context).textTheme.display1.color,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: Ycn.px(90),
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: Ycn.px(10)),
                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('数量', style: TextStyle(fontSize: Ycn.px(26))),
                        CustomCounter(value: this._goodNum, onChange: (val) => setState(() => this._goodNum = val)),
                      ],
                    ),
                  ),
                  Container(
                    height: Ycn.px(90),
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('总计金额', style: TextStyle(fontSize: Ycn.px(26))),
                        Expanded(
                          child: TextField(
                            cursorWidth: Ycn.px(2),
                            focusNode: this._focusNode,
                            textAlign: TextAlign.right,
                            controller: _textEditingController,
                            keyboardType: TextInputType.number,
                            cursorRadius: Radius.circular(Ycn.px(2)),
                            cursorColor: Theme.of(context).accentColor,
                            style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(34)),
                            decoration: InputDecoration(
                              hintText: '请输入总计金额',
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                            ),
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                          ),
                        ),
                        SizedBox(width: Ycn.px(30)),
                        Text('元', style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor)),
                      ],
                    ),
                  ),
                  Container(
                    height: Ycn.px(88),
                    width: Ycn.px(480),
                    margin: EdgeInsets.fromLTRB(Ycn.px(0), Ycn.px(51), Ycn.px(0), Ycn.px(40)),
                    child: FlatButton(
                      onPressed: this._submit,
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(88))),
                      child: Text('录入订单', style: TextStyle(color: Colors.white, fontSize: Ycn.px(34))),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
