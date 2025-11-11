import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  SharedPreferences get _sharedPref => _sharedPrefs!;

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  setString(String key, String value) {
    _sharedPref.setString(key, value);
  }

  String? getString(String key) {
    return _sharedPref.getString(key);
  }

  setStringList(String key, List<String> value) {
    _sharedPref.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _sharedPref.getStringList(key);
  }

  setInt(String key, int value) {
    _sharedPref.setInt(key, value);
  }

  int? getInt(String key) {
    return _sharedPref.getInt(key);
  }

  setDouble(String key, double value) {
    _sharedPref.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _sharedPref.getDouble(key);
  }

  setBool(String key, bool value) {
    _sharedPref.setBool(key, value);
  }

  bool? getBool(String key) {
    return _sharedPref.getBool(key);
  }

  clear() {
    _sharedPref.clear();
  }

  remove(String key) {
    _sharedPref.remove(key);
  }

}

final $sharedPrefs = SharedPrefs();