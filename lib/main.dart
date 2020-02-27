import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'common/Ycn.dart'; // 引入工具库

import 'common/dio.dart'; // 引入 dio 单例

import 'router/routes.dart';
import 'router/onUnknownRoute.dart';
import 'router/onGenerateRoute.dart';
import 'router/navigatorObservers.dart';

import 'package:flutter_localizations/flutter_localizations.dart'; // 语言包

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('main.dart app 初始化');
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)); // 设置状态栏颜色为透明
    dio.options.baseUrl = 'https://yinchengnuo.com/dwbsapp'; // 配置 baseUrl
    // dio.options.baseUrl = 'http://192.168.2.102/dwbsapp'; // 配置 baseUrl
    dio.options.receiveTimeout = 15000; // 配置超时时间
    dio.interceptors.add(CustomInterceptors()); // 配置自定义拦截器
    final Color _themeColor = Color(int.parse('F76454', radix: 16)).withAlpha(255); // 主题色（突出色）
    final Color _mainTextColor = Color(int.parse('333333', radix: 16)).withAlpha(255); // 主要文字颜色
    final Color _secondTextColor = Color(int.parse('666666', radix: 16)).withAlpha(255); // 次要要文字颜色
    final Color _thirdTextColor = Color(int.parse('999999', radix: 16)).withAlpha(255); // 最次要要文字颜色

    return OKToast(
      dismissOtherOnShow: true,
      child: MaterialApp(
        title: '大卫博士', // 在任务管理窗口中所显示的应用名字 <String>
        theme: ThemeData(
          accentColor: _themeColor, // 突出色（主题色）
          primaryColor: _mainTextColor, // 主要文字颜色
          appBarTheme: AppBarTheme(
            color: Colors.white, // 导航栏背景色
            brightness: Brightness.light, // 白天模式（状态栏字体颜色为黑色）
            iconTheme: IconThemeData(color: _mainTextColor), // 返回按钮颜色
            actionsIconTheme: IconThemeData(color: _mainTextColor), // 导航栏右侧菜单样式
            textTheme: TextTheme(title: TextStyle(fontSize: Ycn.px(40), color: _mainTextColor)), // 导航栏标题样式
          ),
          scaffoldBackgroundColor: Color(int.parse('F2F2F2', radix: 16)).withAlpha(255), // 应用背景色
          buttonColor: _themeColor, // 按钮主题色
          iconTheme: IconThemeData(color: _mainTextColor), // Icon 颜色
          textTheme: TextTheme(
            body1: TextStyle(color: _mainTextColor),
            body2: TextStyle(color: _secondTextColor),
            display1: TextStyle(color: _thirdTextColor),
          ), // 文字颜色
          tabBarTheme: TabBarTheme(
            labelPadding: EdgeInsets.all(0),
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontSize: Ycn.px(32)),
            unselectedLabelStyle: TextStyle(fontSize: Ycn.px(32)),
            labelColor: _themeColor,
            unselectedLabelColor: _secondTextColor,
          ),
        ),
        routes: routes, // 路由表
        initialRoute: '/', // 首页路由
        onUnknownRoute: onUnknownRoute, // 未知路由处理方法
        onGenerateRoute: onGenerateRoute, // 全局路由守卫，用于使用命名路由时传参
        navigatorObservers: navigatorObservers, // 应用 Navigator 的监听器
        debugShowCheckedModeBanner: false, // 不显示 debug 图标
        localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        supportedLocales: [const Locale('zh', 'CH')], // 使用中文语言包
      ),
    );
  }
}
