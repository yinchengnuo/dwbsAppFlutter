import 'package:flutter/material.dart';
import '../pages/PageHome/PageHome.dart';
import '../pages/Developing/Developing.dart';
import '../pages/PageWebView/PageWebView.dart';
import '../pages/PageHowToUse/PageHowToUse.dart';
import '../pages/PageManageTeam/PageManageTeam.dart';
import '../pages/PageManageOrder/PageManageOrder.dart';
import '../pages/PageManageFortune/PageManageFortune.dart';

Map routes = <String, WidgetBuilder> { // 路由表
  '/': (ctx) => PageHome(), // app 首页
  '/test': (ctx) => Developing(), // 开发中占位页面
  '/webview': (ctx) => PageWebView(), // webview 页面
  '/how-to-use': (ctx) => PageHowToUse(), // app 使用说明
  '/manage-team': (ctx) => PageManageTeam(), // 订货管理页面
  '/manage-order': (ctx) => PageManageOrder(), // 订货管理页面
  '/manage-fortune': (ctx) => PageManageFortune(), // 订货管理页面
};