import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';

List<NavigatorObserver> navigatorObservers = [ObserverPush(), ObserverPop(), ObserverReplace()];

class ObserverPush extends NavigatorObserver {
  // 监听 app 路由 push 行为
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    dismissAllToast();
  }
}

class ObserverPop extends NavigatorObserver {
  // 监听 app 路由 pop 行为
  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    dismissAllToast();
  }
}

class ObserverReplace extends NavigatorObserver {
  // 监听 app 路由 replace 行为
  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace();
    dismissAllToast();
  }
}
