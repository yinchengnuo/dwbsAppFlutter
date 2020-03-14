// 加入购物车预操作
Map beforeAddToShopCar(goodItem, typeList) {
  goodItem['choosed'] = true; // 将商品设置为默认选中
  goodItem['typeList'] = typeList; // 更新 typeList 获取选中数量
  goodItem['typeList'].forEach((typeItem) {
    typeItem['choosed'] = List(); // 添加选中列表
  });
  goodItem['typeList'].forEach((typeItem) {
    typeItem['size'].forEach((e) {
      typeItem['choosed'].add(true); // 将尺寸设置为默认选中
    });
  });
  return goodItem;
}

// 清除购物车中数量为 0 的 尺寸 类型 商品
List clearShopCarListNumZero(shopCar) {
  for (int a = shopCar.length - 1; a >= 0; a--) {
    final goodItem = shopCar[a];
    for (int b = goodItem['typeList'].length - 1; b >= 0; b--) {
      final typeItem = goodItem['typeList'][b];
      for (int c = typeItem['size'].length - 1; c >= 0; c--) {
        if (typeItem['num'][c] == 0) {
          typeItem['num'].removeAt(c);
          typeItem['size'].removeAt(c);
          typeItem['size_id'].removeAt(c);
          typeItem['choosed'].removeAt(c);
        }
      }
      typeItem['size'].length == 0 ? goodItem['typeList'].removeAt(b) : '';
    }
    goodItem['typeList'].length == 0 ? shopCar.removeAt(a) : '';
  }
  return shopCar;
}
