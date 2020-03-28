import 'package:flutter/material.dart';

class ProviderUserInfo with ChangeNotifier {
  final Map _userinfo = {};

  Map get userinfo => this._userinfo;

  List get authProgress {
    if (this._userinfo['cert_status'].toString() == '1') {
      return [true, true, false, false, false];
    } else if (this._userinfo['cert_status'].toString() == '2') {
      return [true, true, true, true, false];
    } else if (this._userinfo['cert_status'].toString() == '3') {
      return [true, true, true, true, true];
    } else if (this._userinfo['cert_status'].toString() == '4') {
      return [true, true, true, false, false];
    } else if (this._userinfo['cert_status'].toString() == '5') {
      return [true, true, true, true, true];
    }
  }

  void upData(data) {
    data.forEach((key, value) {
      this._userinfo[key] = value;
    });
    notifyListeners();
  }
}
