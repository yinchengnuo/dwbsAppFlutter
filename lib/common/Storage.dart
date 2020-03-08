import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

class Storage {
  static getter(key) {
    if (prefs.getString(key) == null) {
      return '';
    } else if (prefs.getString(key)[0] == '[' || prefs.getString(key)[0] == '{') {
      return jsonDecode(prefs.getString(key));
    } else {
      return prefs.getString(key);
    }
  }

  static setter(key, value) {
    if (value is List || value is Map) {
      prefs.setString(key, jsonEncode(value));
    } else {
      prefs.setString(key, value);
    }
  }

  static delstorage() {}
}
