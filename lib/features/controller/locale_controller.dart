import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  LocaleController();

  Locale _locale = const Locale('pt', 'BR');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) {
      return;
    }
    _locale = locale;
    notifyListeners();
  }
}
