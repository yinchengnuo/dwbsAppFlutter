import 'dart:io';
import '../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';

// 取消回弹效果
class NoBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context, child, axisDirection);
    }
  }
}

// 改变回弹颜色
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return GlowingOverscrollIndicator(child: child, axisDirection: axisDirection, color: Theme.of(context).textTheme.title.color);
    } else {
      return super.buildViewportChrome(context, child, axisDirection);
    }
  }
}

// 自定义modal
class CustomModal extends Dialog {
  final title, content, cancel, input;
  CustomModal({this.title = '提示', this.content, this.cancel = true, this.input});
  TextEditingController _textEditingController = TextEditingController();

  void _comfirm(context) {
    if (this.input != null) {
      this._textEditingController.text.isEmpty
          ? Navigator.of(context).pop()
          : Navigator.of(context).pop({'value': num.parse(this._textEditingController.text)});
    } else {
      Navigator.of(context).pop({});
    }
  }

  Widget build(BuildContext context) {
    if (input != null) {
      this._textEditingController.text = this.input > 0 ? this.input.toString() : '';
    }
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Ycn.px(12)),
        child: Container(
          width: Ycn.px(654),
          height: Ycn.px(456),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                height: Ycn.px(98),
                alignment: Alignment(0, 0),
                child: Text(
                  this.title,
                  style: TextStyle(
                    fontSize: Ycn.px(42),
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              Expanded(
                child: this.input != null
                    ? Center(
                        child: Container(
                          width: Ycn.px(321),
                          height: Ycn.px(147),
                          child: Material(
                            child: TextField(
                              autofocus: true,
                              cursorWidth: Ycn.px(6),
                              textAlign: TextAlign.center,
                              enableInteractiveSelection: false,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(fontSize: Ycn.px(88)),
                              controller: this._textEditingController,
                              cursorRadius: Radius.circular(Ycn.px(2)),
                              cursorColor: Theme.of(context).accentColor,
                              decoration: InputDecoration(border: InputBorder.none),
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                            ),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ...this
                              .content
                              .map(
                                (content) => Container(
                                  margin: EdgeInsets.symmetric(vertical: Ycn.px(2)),
                                  child: Text(
                                    content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: Ycn.px(36),
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                      color: Theme.of(context).textTheme.body1.color,
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                        ],
                      ),
              ),
              Container(
                height: Ycn.px(98),
                decoration: BoxDecoration(border: Border(top: BorderSide(width: Ycn.px(1), color: Theme.of(context).textTheme.display1.color))),
                child: Row(
                  children: <Widget>[
                    this.cancel
                        ? Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(right: BorderSide(width: Ycn.px(1), color: Theme.of(context).textTheme.display1.color))),
                              child: MaterialInkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Center(
                                  child: Text(
                                    '取消',
                                    style: TextStyle(
                                      fontSize: Ycn.px(36),
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                      color: Theme.of(context).textTheme.display1.color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        :Container(width: 0, height: 0),
                    Expanded(
                      child: MaterialInkWell(
                        onTap: () => this._comfirm(context),
                        child: Center(
                          child: Text(
                            '确定',
                            style: TextStyle(
                                fontSize: Ycn.px(36),
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 自定义小圆点
class RedDot extends StatelessWidget {
  final number;
  const RedDot({Key key, this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.number > 0
        ? ConstrainedBox(
            constraints: BoxConstraints(minWidth: Ycn.px(24)),
            child: Container(
              height: Ycn.px(30),
              alignment: Alignment(0, 0),
              padding: EdgeInsets.symmetric(horizontal: Ycn.px(8)),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(Ycn.px(Ycn.px(30)))),
              child: Text(this.number > 999 ? '999+' : this.number.toString(), style: TextStyle(fontSize: Ycn.px(25), color: Colors.white)),
            ),
          )
        :Container(width: 0, height: 0);
  }
}

// 自定义页面 loading
class Loading extends StatelessWidget {
  final loading, child;
  const Loading({Key key, this.loading = false, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          this.child,
          this.loading
              ? Container(alignment: Alignment(0, 0), color: Color.fromRGBO(0, 0, 0, 0.1), child: CircularProgressIndicator())
              :Container(width: 0, height: 0)
        ],
      ),
    );
  }
}

// 自定义计数器
class CustomCounter extends StatelessWidget {
  final value, max, min, onChange;
  const CustomCounter({Key key, this.value, this.max = 999, this.min = 0, this.onChange}) : super(key: key);

  void _add() => this.value == max ? Ycn.toast('数量不能再增加了') : this.onChange(value + 1);
  void _edit(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CustomModal(title: '请输入数量', input: value),
    ).then((res) {
      if (res != null) {
        if (res['value'] >= this.min) {
          this.onChange(res['value']);
        } else {
          this.onChange(1);
          Ycn.toast('数量不能再减少了');
        }
      }
    });
  }

  void _reduce() => this.value == min ? Ycn.toast('数量不能再减少了') : this.onChange(value - 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ycn.px(210),
      height: Ycn.px(50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Ycn.px(5)),
        border: Border.all(width: Ycn.px(1), color: Ycn.getColor('#6C6D70')),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: MaterialInkWell(
              onTap: this._reduce,
              child: Container(
                alignment: Alignment(0, 0),
                decoration: BoxDecoration(border: Border(right: BorderSide(width: Ycn.px(1), color: Ycn.getColor('#6C6D70')))),
                child: Text('-', style: TextStyle(fontSize: Ycn.px(50), color: Theme.of(context).textTheme.display1.color)),
              ),
            ),
          ),
          Expanded(
            child: MaterialInkWell(
              onTap: () => this._edit(context),
              child: Container(
                alignment: Alignment(0, 0),
                decoration: BoxDecoration(border: Border(left: BorderSide(width: Ycn.px(1), color: Ycn.getColor('#6C6D70')))),
                child: Text(this.value.toString(), style: TextStyle(fontSize: Ycn.px(32))),
              ),
            ),
          ),
          Expanded(
            child: MaterialInkWell(
              onTap: this._add,
              child: Container(
                alignment: Alignment(0, 0),
                decoration: BoxDecoration(border: Border(left: BorderSide(width: Ycn.px(1), color: Ycn.getColor('#6C6D70')))),
                child: Text('+', style: TextStyle(fontSize: Ycn.px(36), color: Theme.of(context).accentColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 封装过的水波纹类
class MaterialInkWell extends StatelessWidget {
  final onTap, onLongPress, onTapCancel, child, padding;
  const MaterialInkWell({Key key, this.onTap, this.child, this.padding, this.onLongPress, this.onTapCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Padding(padding: this.padding == null ? EdgeInsets.all(0) : this.padding, child: this.child),
        Material(color: Colors.transparent, child: InkWell(onTap: this.onTap, onLongPress: this.onLongPress))
      ],
    );
  }
}

// 用户等级
class UserLevel extends StatelessWidget {
  final level;
  const UserLevel({Key key, this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ycn.px(130),
      height: Ycn.px(36),
      margin: EdgeInsets.only(left: Ycn.px(18)),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(Ycn.px(18)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ImageIcon(AssetImage('lib/images/public/crown.png'), size: Ycn.px(25), color: Colors.white),
          SizedBox(width: Ycn.px(5)),
          Text(level.toString(), style: TextStyle(fontSize: Ycn.px(20), color: Colors.white))
        ],
      ),
    );
  }
}

// 折线图
class MyLineChart extends StatelessWidget {
  final data, lineColor, backgroundColor;
  const MyLineChart({Key key, this.data, this.lineColor, this.backgroundColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<int> showIndexes = this.data != null ? [...this.data['data'].asMap().keys.toList()] : [];
    final lineBarsData = this.data != null
        ? [
            LineChartBarData(
              spots: [...this.data['data'].asMap().map((index, value) => MapEntry(index, FlSpot(index + 0.0, value + 0.0))).values.toList()],
              isCurved: false,
              colors: [this.lineColor],
              barWidth: Ycn.px(2),
              dotData: FlDotData(show: true, dotColor: this.lineColor),
              belowBarData: BarAreaData(show: false),
            ),
          ]
        : [];
    return this.data == null
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            child: Container(
              height: double.infinity,
              width: Ycn.px(85 * this.data['data'].length),
              child: LineChart(
                LineChartData(
                  backgroundColor: this.backgroundColor, // 图表背景色
                  lineTouchData: LineTouchData(
                    enabled: false,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.transparent,
                      tooltipBottomMargin: Ycn.px(11),
                      tooltipPadding: EdgeInsets.all(0),
                      getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                        return lineBarsSpot.map((lineBarSpot) {
                          return LineTooltipItem(
                            lineBarSpot.y.toString().split('.')[0],
                            TextStyle(fontSize: Ycn.px(24), color: this.lineColor),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  showingTooltipIndicators: showIndexes.map((index) {
                    return MapEntry(index, [LineBarSpot(lineBarsData[0], 0, lineBarsData[0].spots[index])]);
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      margin: Ycn.px(22),
                      textStyle: TextStyle(color: this.lineColor, fontSize: Ycn.px(28)),
                      getTitles: (value) => this.data['date'][int.parse(value.toString().split('.')[0])],
                    ),
                    leftTitles: SideTitles(showTitles: false), // 左侧标题不显示
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(bottom: BorderSide(width: 1, style: BorderStyle.solid, color: this.lineColor)),
                  ),
                  minX: 0,
                  minY: 0,
                  maxX: this.data['data'].length - 1.0,
                  maxY: Ycn.maxOfList(this.data['data']),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      if (value % ((Ycn.maxOfList(this.data['data']) / 6).floor()) == 0) {
                        return FlLine(strokeWidth: Ycn.px(4), color: Colors.white);
                      } else {
                        return FlLine(strokeWidth: 0, color: this.backgroundColor);
                      }
                    },
                  ),
                  axisTitleData: const FlAxisTitleData(
                    rightTitle: AxisTitle(showTitle: true, titleText: ''),
                    leftTitle: AxisTitle(showTitle: true, titleText: ''),
                    topTitle: AxisTitle(showTitle: true, titleText: ''),
                  ),
                  lineBarsData: lineBarsData,
                ),
              ),
            ),
          );
  }
}

// appBar 右上角文字
class AppBarTextAction extends StatelessWidget {
  final text, onTap;
  const AppBarTextAction({Key key, this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ycn.px(118),
      height: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: this.onTap,
          child: Center(
            child: Text(this.text, style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(28))),
          ),
        ),
      ),
    );
  }
}
