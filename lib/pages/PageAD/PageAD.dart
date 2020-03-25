import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dwbs_app_flutter/common/Storage.dart';
import 'package:dwbs_app_flutter/common/components.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageAD extends StatefulWidget {
  PageAD({Key key}) : super(key: key);

  @override
  _PageADState createState() => _PageADState();
}

class _PageADState extends State<PageAD> {
  List<int> _bytesList = List();

  void _getAD() async {
    try {
      await Storage.setter(
        'AD',
        (await Dio().get('https://api.jiuweiyun.cn/public/uploads/images/topics/420.jpg', options: Options(responseType: ResponseType.bytes)))
            .data,
      );
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    this._bytesList = [...Storage.getter('AD')];
    this._getAD();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Image.memory(
                Uint8List.fromList(this._bytesList),
                width: Ycn.screenW(),
                height: Ycn.screenH(),
                fit: BoxFit.fill,
              ),
              Positioned(
                right: Ycn.px(24),
                bottom: Ycn.px(56),
                child: ReduceCounter(),
              )
            ],
          ),
        ));
  }
}

class ReduceCounter extends StatefulWidget {
  ReduceCounter({Key key}) : super(key: key);

  @override
  Reduce_CounterState createState() => Reduce_CounterState();
}

class Reduce_CounterState extends State<ReduceCounter> {
  var _timer;
  int _time = 5;

  void _toHome() {
    this._timer.cancel();
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      this._timer = timer;
      setState(() {
        this._time--;
        if (this._time == 0) {
          this._toHome();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ycn.px(159),
      height: Ycn.px(66),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: Ycn.px(2),
            color: Theme.of(context).accentColor,
          ),
          borderRadius: BorderRadius.circular(Ycn.px(66))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Ycn.px(66)),
        child: MaterialInkWell(
          onTap: this._toHome,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('跳过', style: TextStyle(fontSize: Ycn.px(32), height: 1.1)),
              SizedBox(width: Ycn.px(8)),
              Text(this._time.toString(), style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(32), height: 1.1)),
            ],
          ),
        ),
      ),
    );
  }
}
