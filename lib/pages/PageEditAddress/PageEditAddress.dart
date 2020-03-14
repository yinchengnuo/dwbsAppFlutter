import '../../common/Ycn.dart';
import '../../common/cityPicker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:dwbs_app_flutter/apis/address.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import 'package:dwbs_app_flutter/provider/ProviderAddress.dart';

class PageEditAddress extends StatefulWidget {
  PageEditAddress({Key key}) : super(key: key);

  @override
  _PageEditAddressState createState() => _PageEditAddressState();
}

class _PageEditAddressState extends State<PageEditAddress> {
  Map _routeData;
  String _ssq = '';
  bool isAdd = true;
  bool _loading = false;
  bool _requesting = false;
  String _areaID = '410105';
  ProviderAddress __address;

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

  // 根据省市区字符串获取 areaID
  String _getAreaID(p, c, a) {
    final String provincesID = provincesData.keys.toList()[provincesData.values.toList().indexOf(p)];
    final String cityID = citiesData[provincesID].keys.toList()[citiesData[provincesID].values.toList().indexWhere((item) {
      return item['name'] == c;
    })];
    return citiesData[cityID].keys.toList()[citiesData[cityID].values.toList().indexWhere((item) {
      return item['name'] == a;
    })];
  }

  // 选择省市区
  void _chooseSSQ() async {
    this._pulldownKB();
    final res = await CityPickers.showCityPicker(
      context: context,
      height: Ycn.px(567),
      itemExtent: Ycn.px(123),
      locationCode: this._areaID,
      barrierDismissible: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      confirmWidget: Container(child: Text('确定', style: TextStyle(fontSize: Ycn.px(38), color: Theme.of(context).accentColor))),
      cancelWidget: Container(child: Text('取消', style: TextStyle(fontSize: Ycn.px(38), color: Ycn.getColor('#AAAAAA')))),
    );
    if (res != null) {
      setState(() {
        this._ssq = '${res.provinceName}-${res.cityName}-${res.areaName}';
        this._areaID = this._getAreaID(res.provinceName, res.cityName, res.areaName);
      });
    }
  }

  // 点击保存地址
  void _confirm() {
    this._pulldownKB();
    if (!RegExp(r'^[\u4E00-\u9FA5\uf900-\ufa2d·s]{2,20}$').hasMatch(this._textEditingController1.text)) {
      Ycn.toast('请输入正确的真实姓名');
      return;
    }
    if (this._textEditingController2.text.length < 5) {
      Ycn.toast('请输入正确的手机号');
      return;
    }
    if (this._ssq.isEmpty) {
      Ycn.toast('请选择省市区');
      return;
    }
    if (this._textEditingController3.text.length < 2) {
      Ycn.toast('请填写详细的详细地址');
      return;
    }
    final address = {
      'con_name': this._textEditingController1.text,
      'con_mobile': this._textEditingController2.text,
      'provice': this._ssq.split('-')[0],
      'city': this._ssq.split('-')[1],
      'area': this._ssq.split('-')[2],
      'address': this._textEditingController3.text,
    };
    if (this.isAdd) {
      if (!this._requesting) {
        setState(() {
          this._loading = true;
          this._requesting = true;
        });
        apiAddressAdd(address).then((status) {
          address['id'] = status.data['data']['id'].toString();
          this.__address.add(address);
          Navigator.of(context).pop({});
        }).whenComplete(() {
          setState(() {
            this._loading = false;
            this._requesting = false;
          });
        });
      }
    } else {
      address['id'] = this._routeData['id'];
      if (!this._requesting) {
        setState(() {
          this._loading = true;
          this._requesting = true;
        });
        apiAddressUpdata(address).then((status) {
          this.__address.updata(address);
          Navigator.of(context).pop({});
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
    final Map routeData = ModalRoute.of(context).settings.arguments as Map;
    if (routeData != null && this._routeData == null) {
      this.isAdd = false;
      this._routeData = routeData;
      this._textEditingController1.text = this._routeData['con_name'];
      this._textEditingController2.text = this._routeData['con_mobile'];
      this._textEditingController3.text = this._routeData['address'];
      setState(() {
        this._ssq = Ycn.formatAddress(this._routeData, split: true)[0];
        this._areaID = this._getAreaID(this._routeData['provice'], this._routeData['city'], this._routeData['area']);
      });
    }
    return Consumer(builder: (BuildContext context, ProviderAddress address, Widget child) {
      this.__address = address;
      return Loading(
        loading: this._loading,
        child: Scaffold(
          appBar: Ycn.appBar(context, title: this.isAdd ? '新增地址' : '编辑地址'),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: Ycn.px(94),
                color: Colors.white,
                margin: EdgeInsetsDirectional.only(bottom: Ycn.px(1)),
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: Ycn.px(175),
                      alignment: Alignment(-1, 0),
                      child: Text('姓名', style: TextStyle(fontSize: Ycn.px(32))),
                    ),
                    Expanded(
                      child: TextField(
                        maxLines: 1,
                        cursorWidth: Ycn.px(6),
                        focusNode: this._focusNode1,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: this._textEditingController1,
                        cursorRadius: Radius.circular(Ycn.px(2)),
                        cursorColor: Theme.of(context).accentColor,
                        style: TextStyle(fontSize: Ycn.px(34), height: 1.25),
                        decoration: InputDecoration(
                          hintText: '请填写真实姓名',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Theme.of(context).textTheme.display1.color),
                        ),
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: Ycn.px(94),
                color: Colors.white,
                margin: EdgeInsetsDirectional.only(bottom: Ycn.px(1)),
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: Ycn.px(175),
                      alignment: Alignment(-1, 0),
                      child: Text('手机号', style: TextStyle(fontSize: Ycn.px(32))),
                    ),
                    Expanded(
                      child: TextField(
                        maxLines: 1,
                        cursorWidth: Ycn.px(6),
                        focusNode: this._focusNode2,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        controller: this._textEditingController2,
                        cursorRadius: Radius.circular(Ycn.px(2)),
                        cursorColor: Theme.of(context).accentColor,
                        style: TextStyle(fontSize: Ycn.px(34), height: 1.25),
                        decoration: InputDecoration(
                          hintText: '请填写手机号码',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Theme.of(context).textTheme.display1.color),
                        ),
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: Ycn.px(94),
                color: Colors.white,
                margin: EdgeInsetsDirectional.only(bottom: Ycn.px(1)),
                child: MaterialInkWell(
                  onTap: this._chooseSSQ,
                  padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: Ycn.px(175),
                        alignment: Alignment(-1, 0),
                        child: Text('所在地区', style: TextStyle(fontSize: Ycn.px(32))),
                      ),
                      Expanded(
                          child: Container(
                              child: Text(
                        this._ssq,
                        style: TextStyle(fontSize: Ycn.px(34)),
                      ))),
                      Icon(Icons.arrow_forward_ios, size: Ycn.px(34), color: Ycn.getColor('#B7B7B7'))
                    ],
                  ),
                ),
              ),
              Container(
                height: Ycn.px(94),
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: Ycn.px(175),
                      alignment: Alignment(-1, 0),
                      child: Text('详细地址', style: TextStyle(fontSize: Ycn.px(32))),
                    ),
                    Expanded(
                      child: TextField(
                        cursorWidth: Ycn.px(6),
                        focusNode: this._focusNode3,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: this._textEditingController3,
                        cursorRadius: Radius.circular(Ycn.px(2)),
                        cursorColor: Theme.of(context).accentColor,
                        style: TextStyle(fontSize: Ycn.px(34), height: 1.25),
                        decoration: InputDecoration(
                          hintText: '请填写详细地址',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Theme.of(context).textTheme.display1.color),
                        ),
                        inputFormatters: [LengthLimitingTextInputFormatter(32)],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: Ycn.px(630),
                height: Ycn.px(88),
                margin: EdgeInsets.only(top: Ycn.px(70)),
                child: FlatButton(
                  onPressed: this._confirm,
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(88))),
                  child: Text('保存地址', style: TextStyle(fontSize: Ycn.px(34), color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
