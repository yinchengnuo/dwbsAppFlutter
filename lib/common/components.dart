import 'dart:io';
import '../common/Ycn.dart';
import 'package:flutter/material.dart';
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
