import 'dart:ui';
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
        child: AppBar(
          title: Text(title),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: transparent == false ? px(1) : 0,
          backgroundColor: transparent == false ? Colors.white : Colors.transparent,
          leading: back
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: Ycn.px(40)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
              : null,
          actions: action == false ? <Widget>[] : <Widget>[action],
        ),
        preferredSize: Size.fromHeight(px(86)),
      );

  // 格式化时间
  static List formatTime(time) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return [
      date.year.toString().length == 1 ? '0${date.year.toString()}' : date.year.toString(),
      date.month.toString().length == 1 ? '0${date.month.toString()}' : date.month.toString(),
      date.weekday.toString().length == 1 ? '0${date.weekday.toString()}' : date.weekday.toString(),
      date.day.toString().length == 1 ? '0${date.day.toString()}' : date.day.toString(),
      date.hour.toString().length == 1 ? '0${date.hour.toString()}' : date.hour.toString(),
      date.minute.toString().length == 1 ? '0${date.minute.toString()}' : date.minute.toString()
    ];
  }

  static String numDot(string) => string.toString().replaceAllMapped(RegExp(r"(\d)(?=(?:\d{3})+\b)"), (match) => '${match.group(1)},');

  // toast 方法
  static void toast(info) => showToastWidget(
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Ycn.px(567)),
          child: Container(
            padding: EdgeInsets.fromLTRB(Ycn.px(24), Ycn.px(12), Ycn.px(24), Ycn.px(12)),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(px(8)), color: Color.fromRGBO(0, 0, 0, 0.6)),
            child: Text(info.toString(), style: TextStyle(fontSize: Ycn.px(26), height: 1.5, letterSpacing: Ycn.px(2))),
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
}
