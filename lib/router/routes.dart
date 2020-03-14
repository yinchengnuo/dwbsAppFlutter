import '../pages/AllIcon/AllIcon.dart';
import 'package:flutter/material.dart';
import '../pages/PageHome/PageHome.dart';
import '../pages/PageLogin/PageLogin.dart';
import '../pages/Developing/Developing.dart';
import '../pages/PageShopCar/PageShopCar.dart';
import '../pages/PageWebView/PageWebView.dart';
import '../pages/PageMyOrder/PageMyOrder.dart';
import '../pages/PageMyStock/PageMyStock.dart';
import '../pages/PageAboutUs/PageAboutUs.dart';
import '../pages/PageAppRules/PageAppRules.dart';
import '../pages/PageGoodList/PageGoodList.dart';
import '../pages/PageHowToUse/PageHowToUse.dart';
import '../pages/PageSendGood/PageSendGood.dart';
import '../pages/PageDownOrder/PageDownOrder.dart';
import '../pages/PagePhoneArea/PagePhoneArea.dart';
import '../pages/PageSystemSet/PageSystemSet.dart';
import '../pages/PageChooseSize/PageChooseSize.dart';
import '../pages/PageGoodDetail/PageGoodDetail.dart';
import '../pages/PageManageTeam/PageManageTeam.dart';
import '../pages/PageSafeManage/PageSafeManage.dart';
import '../pages/PageManageOrder/PageManageOrder.dart';
import '../pages/PageEditAddress/PageEditAddress.dart';
import '../pages/PageOrderDetail/PageOrderDetail.dart';
import '../pages/PageSendSuccess/PageSendSuccess.dart';
import '../pages/PageAuthIdentity/PageAuthIdentity.dart';
import '../pages/PageAuthProgress/PageAuthProgress.dart';
import '../pages/PageConfirmOrder/PageConfirmOrder.dart';
import '../pages/PageMessageOrder/PageMessageOrder.dart';
import '../pages/PageManageFortune/PageManageFortune.dart';
import '../pages/PageAddressManage/PageAddressManage.dart';
import '../pages/PageMessageSystem/PageMessageSystem.dart';
import '../pages/PageProblemFeedback/PageProblemFeedback.dart';
import '../pages/PageMessageNotification/PageMessageNotification.dart';

Map routes = <String, WidgetBuilder>{
  '/icon': (ctx) => AllIcon(), // 图标
  '/home': (ctx) => PageHome(), // app 首页
  '/test': (ctx) => Developing(), // 开发中页面
  '/login': (ctx) => PageLogin(), // 登陆注册页面
  '/webview': (ctx) => PageWebView(), // webview 页面
  '/shop-car': (ctx) => PageShopCar(), // 购物车页面
  '/my-order': (ctx) => PageMyOrder(), // 我的订单页面
  '/my-stock': (ctx) => PageMyStock(), // 地址管理页面
  '/about-us': (ctx) => PageAboutUs(), // 关于我们页面
  '/app-rules': (ctx) => PageAppRules(), // 隐私协议页面
  '/good-list': (ctx) => PageGoodList(), // 订单列表页面
  '/send-good': (ctx) => PageSendGood(), // 发货确认页面
  '/how-to-use': (ctx) => PageHowToUse(), // app 使用说明
  '/system-set': (ctx) => PageSystemSet(), // 系统设置页面
  '/phone-area': (ctx) => PagePhoneArea(), // 选择国家地区页面
  '/down-order': (ctx) => PageDownOrder(), // 下级订单页面
  '/manage-team': (ctx) => PageManageTeam(), // 团队管理页面
  '/good-detail': (ctx) => PageGoodDetail(), // 商品详情页面
  '/choose-size': (ctx) => PageChooseSize(), // 选择尺寸页面
  '/safe-manage': (ctx) => PageSafeManage(), // 安全中心页面
  '/manage-order': (ctx) => PageManageOrder(), // 订货管理页面
  '/edit-address': (ctx) => PageEditAddress(), // 新增/编辑地址页面
  '/order-detail': (ctx) => PageOrderDetail(), // 订单详情页面
  '/send-success': (ctx) => PageSendSuccess(), // 发货成功页面
  '/message-order': (ctx) => PageMessageOrder(), // 订单通知页面
  '/confirm-order': (ctx) => PageConfirmOrder(), // 确定订单页面
  '/auth-identity': (ctx) => PageAuthIdentity(), // 身份认证页面
  '/auth-progress': (ctx) => PageAuthProgress(), // 审核进度页面页面
  '/message-system': (ctx) => PageMessageSystem(), // 系统通知页面
  '/manage-fortune': (ctx) => PageManageFortune(), // 财富管理页面
  '/address-manage': (ctx) => PageAddressManage(), // 地址管理页面
  '/problem-feedback': (ctx) => PageProblemFeedback(), // 问题反馈页面
  '/message-notification': (ctx) => PageMessageNotification(), // 消息通知页面
};
