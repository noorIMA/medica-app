import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale('ar');

  Locale get locale => _locale;
  String get localeString => _locale.languageCode;

  void setLocale(Locale locale) {
    if (!['en', 'ar'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = Locale('ar');
    notifyListeners();
  }
}
