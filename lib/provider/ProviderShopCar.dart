import 'package:flutter/material.dart';
import '../common/shopCar.dart';
import '../common/Ycn.dart';

class ProviderShopCar with ChangeNotifier {
  List _shopCarList = [];

  List get shopCar => this._shopCarList;

  // 获取购物车商品总数量
  int get totalNum {
    return this._shopCarList.fold(0, (t, e) {
      return e['typeList'].fold(t, (tt, ee) {
        return ee['num'].fold(tt, (ttt, eee) {
          return ttt + eee;
        });
      });
    });
  }

  // 获取购物车已选中商品总数量
  int get totalChoosedNum {
    return this._shopCarList.fold(0, (t, e) {
      return e['typeList'].fold(t, (tt, ee) {
        return ee['size'].fold(tt, (ttt, eee) {
          return ttt + (ee['choosed'][ee['size'].indexOf(eee)] ? ee['num'][ee['size'].indexOf(eee)] : 0);
        });
      });
    });
  }

  // 获取购物车已选中商品总价值
  int get totalChoosedPrice {
    return this._shopCarList.fold(0, (t, e) {
      return e['typeList'].fold(t, (tt, ee) {
        return ee['size'].fold(tt, (ttt, eee) {
          return ttt + (ee['choosed'][ee['size'].indexOf(eee)] ? ee['num'][ee['size'].indexOf(eee)] * e['price'] : 0);
        });
      });
    });
  }

  // 购物车商品是否为全选状态
  bool get isAllChoosed {
    return this._shopCarList.every((e) {
      return true ==
          e['typeList'].every((ee) {
            return true ==
                ee['choosed'].every((eee) {
                  return true == eee;
                });
          });
    });
  }

  // 改变购物车选中状态
  void chooseChange(infoList) {
    if (infoList.length == 1) {
      this._shopCarList.forEach((goodItem) {
        goodItem['choosed'] = !infoList[0];
        goodItem['typeList'].forEach((typeItem) {
          typeItem['choosed'] = typeItem['choosed'].map((e) => !infoList[0]).toList();
        });
      });
    } else if (infoList.length == 2) {
      this._shopCarList[infoList[0]]['choosed'] = !infoList[1];
      this._shopCarList[infoList[0]]['typeList'].forEach((typeItem) {
        typeItem['choosed'] = typeItem['choosed'].map((e) => !infoList[1]).toList();
      });
    } else if (infoList.length == 4) {
      this._shopCarList[infoList[0]]['typeList'][infoList[1]]['choosed'][infoList[2]] = !infoList[3];
      this._shopCarList[infoList[0]]['choosed'] = this._shopCarList[infoList[0]]['typeList'].every((typeItem) {
        return true ==
            typeItem['choosed'].every((choosedItem) {
              return true == choosedItem;
            });
      });
    }
    notifyListeners();
  }

  // 修改购物车商品数量
  void numChange(goodIndex, typeIndex, sizeIndex, val) {
    this._shopCarList[goodIndex]['typeList'][typeIndex]['num'][sizeIndex] = val;
    clearShopCarListNumZero(this._shopCarList); // 清理购物车中数量为 0 的商品
    notifyListeners();
  }

  // 加入购物车
  void add(item) {
    final itemIndex = this._shopCarList.indexWhere((goodItem) => goodItem['id'] == item['id']);
    if (itemIndex == -1) {
      this._shopCarList.add(item); // 如果购物车中没有此商品，直接加入
    } else {
      final nowItem = this._shopCarList[itemIndex];
      item['typeList'].forEach((typeItem) {
        nowItem['typeList'].forEach((nowTypeItem) {
          if (typeItem['type_id'] == nowTypeItem['type_id']) {
            typeItem['size'].forEach((sizeItem) {
              nowTypeItem['size'].forEach((nowSizeItem) {
                if (sizeItem == nowSizeItem) {
                  typeItem['num'][typeItem['size'].indexOf(sizeItem)] += nowTypeItem['num'][nowTypeItem['size'].indexOf(nowSizeItem)];
                  typeItem['choosed'][typeItem['size'].indexOf(sizeItem)] = true;
                }
              });
            });
          }
        });
      });
      this._shopCarList[itemIndex] = item;
    }
    clearShopCarListNumZero(this._shopCarList); // 清理购物车中数量为 0 的商品
    notifyListeners();
  }

  // 从购物车删除某件商品
  void delGood(goodIndex) {
    this._shopCarList.removeAt(goodIndex);
    notifyListeners();
  }

  // 从购物车删除已选中件商品
  void delChoosed() {
    this._shopCarList.forEach((goodItem) {
      goodItem['typeList'].forEach((typeItem) {
        typeItem['size'].forEach((sizeItem) {
          if (typeItem['choosed'][typeItem['size'].indexOf(sizeItem)]) {
            typeItem['num'][typeItem['size'].indexOf(sizeItem)] = 0; // 将要选中的的尺寸数量改为 0
          }
        });
      });
    });
    clearShopCarListNumZero(this._shopCarList); // 清理购物车中数量为 0 的商品
    notifyListeners();
  }
}
