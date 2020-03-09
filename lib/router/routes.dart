import 'package:flutter/material.dart';
import '../pages/PageHome/PageHome.dart';
import '../pages/PageLogin/PageLogin.dart';
import '../pages/Developing/Developing.dart';
import '../pages/PageShopCar/PageShopCar.dart';
import '../pages/PageWebView/PageWebView.dart';
import '../pages/PageGoodList/PageGoodList.dart';
import '../pages/PageHowToUse/PageHowToUse.dart';
import '../pages/PagePhoneArea/PagePhoneArea.dart';
import '../pages/PageSystemSet/PageSystemSet.dart';
import '../pages/PageChooseSize/PageChooseSize.dart';
import '../pages/PageGoodDetail/PageGoodDetail.dart';
import '../pages/PageManageTeam/PageManageTeam.dart';
import '../pages/PageManageOrder/PageManageOrder.dart';
import '../pages/PageManageFortune/PageManageFortune.dart';

Map routes = <String, WidgetBuilder>{
  '/home': (ctx) => PageHome(), // app 首页
  '/test': (ctx) => Developing(), // 开发中页面
  '/login': (ctx) => PageLogin(), // 登陆注册页面
  '/webview': (ctx) => PageWebView(), // webview 页面
  '/shop-car': (ctx) => PageShopCar(), // 购物车页面
  '/good-list': (ctx) => PageGoodList(), // 订单列表页面
  '/how-to-use': (ctx) => PageHowToUse(), // app 使用说明
  '/system-set': (ctx) => PageSystemSet(), // 系统设置页面
  '/phone-area': (ctx) => PagePhoneArea(), // 选择国家地区页面
  '/manage-team': (ctx) => PageManageTeam(), // 团队管理页面
  '/good-detail': (ctx) => PageGoodDetail(), // 商品详情页面
  '/choose-size': (ctx) => PageChooseSize(), // 选择尺寸页面
  '/manage-order': (ctx) => PageManageOrder(), // 订货管理页面
  '/manage-fortune': (ctx) => PageManageFortune(), // 财富管理页面
};
