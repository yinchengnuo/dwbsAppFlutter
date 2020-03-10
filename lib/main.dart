
import 'common/Ycn.dart'; // 引入工具库
import 'common/dio.dart'; // 引入 dio 单例
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'router/routes.dart';
import 'router/onUnknownRoute.dart';
import 'router/onGenerateRoute.dart';
import 'router/navigatorObservers.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:flutter_localizations/flutter_localizations.dart'; // 语言包

import 'common/Storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart'; // 引入 provider
import 'provider/ProviderComm.dart'; // 社区相关状态
import 'provider/ProviderShopCar.dart'; // 购物车相关状态
import 'provider/ProviderChoosedSize.dart'; // 已选中商品相关状态
import 'provider/ProviderUserInfo.dart'; // 用户信心状态

import 'package:dwbs_app_flutter/pages/PageHome/PageHome.dart';
import 'package:dwbs_app_flutter/pages/PageLogin/PageLogin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)); // 设置状态栏颜色为透明
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color _themeColor = Ycn.getColor('#F76454'); // 主题色（突出色）
  final Color _mainTextColor = Ycn.getColor('#333333'); // 主要文字颜色
  final Color _secondTextColor = Ycn.getColor('#666666'); // 次要要文字颜色
  final Color _thirdTextColor = Ycn.getColor('#999999'); // 最次要要文字颜色

  // Future _initWx() async {
  //   // if (await fluwx.isWeChatInstalled()) {
  //   //   await fluwx.registerWxApi(appId: 'wxd930ea5d5a258f4f');
  //   //   print('初始化完成');
  //   // } else {
  //   //   print('微信未安装');
  //   // }
  //   var a = await fluwx.registerWxApi(appId: 'wxd930ea5d5a258f4f');
  //   print(a);
  // }

  @override
  void initState() {
    super.initState();
    // dio.options.baseUrl = 'https://yinchengnuo.com/dwbsapp'; // 配置 baseUrl
    // dio.options.baseUrl = 'http://192.168.2.110/dwbsapp'; // 配置 baseUrl
    dio.options.baseUrl = 'http://192.168.0.101/dwbsapp'; // 配置 baseUrl
    dio.options.receiveTimeout = 15000; // 配置超时时间
    dio.interceptors.add(CustomInterceptors()); // 配置自定义拦截器
    // this._initWx(); // 初始化微信
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderComm()),
        ChangeNotifierProvider(create: (_) => ProviderShopCar()),
        ChangeNotifierProvider(create: (_) => ProviderUserInfo()),
        ChangeNotifierProvider(create: (_) => ProviderChoosedSize()),
      ],
      child: OKToast(
        dismissOtherOnShow: true,
        child: MaterialApp(
          title: '大卫博士', // 在任务管理窗口中所显示的应用名字 <String>
          theme: ThemeData(
            accentColor: this._themeColor, // 突出色（主题色）
            primaryColor: this._mainTextColor, // 主要文字颜色
            appBarTheme: AppBarTheme(
              color: Colors.white, // 导航栏背景色
              brightness: Brightness.light, // 白天模式（状态栏字体颜色为黑色）
              iconTheme: IconThemeData(color: this._mainTextColor), // 返回按钮颜色
              actionsIconTheme: IconThemeData(color: this._mainTextColor), // 导航栏右侧菜单样式
              textTheme: TextTheme(title: TextStyle(fontSize: Ycn.px(40), color: this._mainTextColor)), // 导航栏标题样式
            ),
            scaffoldBackgroundColor: Ycn.getColor('#F2F2F2'), // 应用背景色
            buttonColor: this._themeColor, // 按钮主题色
            iconTheme: IconThemeData(color: this._mainTextColor), // Icon 颜色
            textTheme: TextTheme(
              body1: TextStyle(color: this._mainTextColor, height: 1),
              body2: TextStyle(color: this._secondTextColor, height: 1),
              display1: TextStyle(color: this._thirdTextColor, height: 1),
            ), // 文字颜色
            tabBarTheme: TabBarTheme(
              labelPadding: EdgeInsets.all(0),
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontSize: Ycn.px(32)),
              unselectedLabelStyle: TextStyle(fontSize: Ycn.px(32)),
              labelColor: this._themeColor,
              unselectedLabelColor: this._secondTextColor,
            ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.iOS: MyPageTransitionsBuilder(),
                TargetPlatform.android: MyPageTransitionsBuilder(),
              },
            ),
          ),
          routes: routes,
          home: Storage.getter('token').toString().isEmpty ? PageLogin() : PageHome(),
          onUnknownRoute: onUnknownRoute, // 未知路由处理方法
          onGenerateRoute: onGenerateRoute, // 全局路由守卫，用于使用命名路由时传参
          navigatorObservers: navigatorObservers, // 应用 Navigator 的监听器
          debugShowCheckedModeBanner: false, // 不显示 debug 图标
          localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
          supportedLocales: [const Locale('zh', 'CH')], // 使用中文语言包
        ),
      ),
    );
  }
}

// 自定义全局路由动画
class MyPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(route, context, animation, secondaryAnimation, child) {
    return ScaleTransition(scale: animation, child: RotationTransition(turns: animation, child: child));
  }
}
