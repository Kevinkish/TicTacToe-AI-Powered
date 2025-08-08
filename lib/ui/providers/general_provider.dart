import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralProvider extends ChangeNotifier {
  SharedPreferences? pref;

  //Fetching all preferences
  void getPrefs(SharedPreferences p) {
    pref = p;
    _isDark = pref!.getBool('isDark') ?? false;
    notifyListeners();
  }

  //Theme handling
  bool _isDark = false;

  bool get isDark => _isDark;

  void changeTheme(bool themeValue) {
    _isDark = themeValue;
    if (pref != null) pref!.setBool('isDark', _isDark);
    notifyListeners();
  }

  void recharge(dynamic widget) {
    widget = widget;
    notifyListeners();
  }
}
