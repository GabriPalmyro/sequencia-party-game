import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDatabase {
  Future<void> saveData(String key, dynamic value);
  Future<dynamic> getData(String key);
  Future<void> removeData(String key);
}

@LazySingleton(as: LocalDatabase)
class SharedPreferencesDatabase implements LocalDatabase {
  SharedPreferencesDatabase() {
    _init();
  }

  late SharedPreferences _preferences;

  Future<void> _init() async {
    log('Initializing SharedPreferences');
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> saveData(String key, dynamic value) async {
    if (value is String) {
      await _preferences.setString(key, value);
    } else if (value is int) {
      await _preferences.setInt(key, value);
    } else if (value is double) {
      await _preferences.setDouble(key, value);
    } else if (value is bool) {
      await _preferences.setBool(key, value);
    } else if (value is List<String>) {
      await _preferences.setStringList(key, value);
    } else {
      throw Exception('Unsupported data type');
    }
  }

  @override
  Future<dynamic> getData(String key) async {
    _preferences = await SharedPreferences.getInstance();

    return _preferences.get(key);
  }

  @override
  Future<void> removeData(String key) async {
    await _preferences.remove(key);
  }
}
