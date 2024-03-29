import 'dart:ui';
import 'dart:convert';
import 'components.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Ycn {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;
  static double _ratio = _width / 750;

  static px(number) => number * _ratio;

  static screenW() => _width;

  static screenH() => _height;

  // 生成自定义 appBar
  static appBar(context, {back: true, title: '', action: false, transparent: false}) => PreferredSize(
        preferredSize: Size.fromHeight(Ycn.px(86)),
        child: AppBar(
          title: GestureDetector(onLongPress: () => Navigator.of(context).pushNamed('/icon'), child: Text(title)),
          centerTitle: true,
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          elevation: transparent == false ? px(1) : 0,
          backgroundColor: transparent == false ? Colors.white : Colors.transparent,
          leading: back ? IconButton(icon: Icon(Icons.arrow_back_ios, size: Ycn.px(40)), onPressed: () => Navigator.of(context).pop()) : null,
          actions: action == false ? <Widget>[] : <Widget>[action],
        ),
      );

  // 格式化时间
  static formatTime(time, {array: false}) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(time.toString()));
    final arr = [
      date.year.toString().length == 1 ? '0${date.year.toString()}' : date.year.toString(),
      date.month.toString().length == 1 ? '0${date.month.toString()}' : date.month.toString(),
      date.weekday.toString().length == 1 ? '0${date.weekday.toString()}' : date.weekday.toString(),
      date.day.toString().length == 1 ? '0${date.day.toString()}' : date.day.toString(),
      date.hour.toString().length == 1 ? '0${date.hour.toString()}' : date.hour.toString(),
      date.minute.toString().length == 1 ? '0${date.minute.toString()}' : date.minute.toString()
    ];
    return array ? arr : '${arr[0]}-${arr[1]}-${arr[3]} ${arr[4]}:${arr[5]}';
  }

  // 数字打点
  static String numDot(string) => string.toString().replaceAllMapped(RegExp(r"(\d)(?=(?:\d{3})+\b)"), (match) => '${match.group(1)},');

  // toast 方法
  static void toast(info) => showToastWidget(
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Ycn.px(567)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: Ycn.px(8), horizontal: Ycn.px(12)),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(px(8)), color: Color.fromRGBO(0, 0, 0, 0.6)),
            child: Text(info.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: Ycn.px(32), height: 1.25, letterSpacing: Ycn.px(2))),
          ),
        ),
      );

  // 取数组最大数值
  static double maxOfList(list) {
    double max = 0;
    list.forEach((item) {
      item += 0.0;
      if (item > max) {
        max = item;
      }
    });
    return max;
  }

  // 颜色字符串转 Color
  static Color getColor(string) => Color(int.parse(string.toString().replaceAll('#', ''), radix: 16)).withAlpha(255);

  // 等待不为 null 时取值
  static String waitString(data, key) => data == null ? '' : data[key].toString();

  // 克隆
  static clone(map) => map is String ? jsonDecode(map) : jsonDecode(jsonEncode(map));

  // modal 文字
  static modal(context, {title, content, cancel, inputNum, back = true}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => back,
        child: CustomModal(title: title, content: content, cancel: cancel, inputNum: inputNum),
      ),
    );
  }

  // modal 图片
  static modalImg(context, img, width, height, {back = true}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => back,
        child: CustomModal(img: img, width: width, height: height),
      ),
    );
  }

  // modal app 升级页
  static modalUpdata(context, version, message) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => UpdataModal(version: version, message: message),
    );
  }

  // 格式化地址
  static formatAddress(address, {split: false}) {
    if (split) {
      return [
        '${address['provice'].toString()}-${address['city'].toString()}-${address['area'].toString()}',
        '${address['address'].toString()}',
      ];
    } else {
      return '${address['provice'].toString()}-${address['city'].toString()}-${address['area'].toString()}-${address['address'].toString()}';
    }
  }

  // 格式化订单状态
  static formatOrderStatus(status) {
    switch (status.toString()) {
      case '0':
        return '待付款';
      case '1':
        return '待发货';
      case '2':
        return '待收货';
      case '3':
        return '已完成';
      case '4':
        return '已取消';
      default:
        return '';
    }
  }

  // 格式化收入类型
  static formatIncomeType(status) {
    switch (status.toString()) {
      case '0':
        return '订单收入';
      case '1':
        return '零售收入';
      case '2':
        return '邀请奖励';
      case '3':
        return '店铺奖励';
      case '4':
        return '业绩奖励';
      default:
        return '';
    }
  }
}
