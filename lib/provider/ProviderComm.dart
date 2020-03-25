import 'package:flutter/material.dart';
import '../apis/comm.dart';

class ProviderComm with ChangeNotifier {
  final List<List> _commList = [[], [], [], []];

  Map _indexArticle;

  List get commList => this._commList;
  Map get indexArticle => this._indexArticle;

  void upData(index, data) {
    if (index == -1) {
      this._indexArticle = data;
    } else {
      this._commList[index] = data;
    }
    notifyListeners();
  }

  void thumb(type, index) {
    if (type == -1) {
      this._indexArticle['like'] = !this._indexArticle['like'];
    } else {
      this._commList[type][index]['like'] = !this._commList[type][index]['like'];
    }
    apiCommListItemAction({
      'type': 0,
      'status': (type == -1 ? this.indexArticle['like'] : this._commList[type][index]['like']) ? 1 : 0,
      'id': type == -1 ? this._indexArticle['id'] : this._commList[type][index]['id'],
    });
    notifyListeners();
  }

  void collection(type, index) {
    if (type == -1) {
      this._indexArticle['collection'] = !this._indexArticle['collection'];
    } else {
      this._commList[type][index]['collection'] = !this._commList[type][index]['collection'];
    }
    apiCommListItemAction({
      'type': 1,
      'status': (type == -1 ? this.indexArticle['collection'] : this._commList[type][index]['collection']) ? 1 : 0,
      'id': type == -1 ? this._indexArticle['id'] : this._commList[type][index]['id'],
    });
    notifyListeners();
  }
}
