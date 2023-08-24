import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImmAppLangCon extends ChangeNotifier {
  Locale _appLocale = const Locale('en');

  Locale get appLocal => _appLocale;
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = const Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code').toString());
    return Null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == const Locale("ar")) {
      _appLocale = const Locale("ar");
      await prefs.setString('language_code', 'ar');
      await prefs.setString('countryCode', '');
    } else if (type == const Locale("de")) {
      _appLocale = const Locale("de");
      await prefs.setString('language_code', 'de');
      await prefs.setString('countryCode', '');
    } else if (type == const Locale("es")) {
      _appLocale = const Locale("es");
      await prefs.setString('language_code', 'es');
      await prefs.setString('countryCode', '');
    } else if (type == const Locale("fi")) {
      _appLocale = const Locale("fi");
      await prefs.setString('language_code', 'fi');
      await prefs.setString('countryCode', '');
    } else if (type == const Locale("fr")) {
      _appLocale = const Locale("fr");
      await prefs.setString('language_code', 'fr');
      await prefs.setString('countryCode', '');
    } else if (type == const Locale("it")) {
      _appLocale = const Locale("it");
      await prefs.setString('language_code', 'it');
      await prefs.setString('countryCode', '');
    } else if (type == const Locale("nl")) {
      _appLocale = const Locale("nl");
      await prefs.setString('language_code', 'nl');
      await prefs.setString('countryCode', '');
    } else if (type == const Locale("nb")) {
      _appLocale = const Locale("nb");
      await prefs.setString('language_code', 'nb');
      await prefs.setString('countryCode', '');
    } else if (type == const Locale("it")) {
      _appLocale = const Locale("it");
      await prefs.setString('language_code', 'it');
      await prefs.setString('countryCode', 'IT');
    } else if (type == const Locale("pt")) {
      _appLocale = const Locale("pt");
      await prefs.setString('language_code', 'pt');
      await prefs.setString('countryCode', '');
    } else if (type == const Locale("ru")) {
      _appLocale = const Locale("ru");
      await prefs.setString('language_code', 'ru');
      await prefs.setString('countryCode', '');
    } else if (type == const Locale("sv")) {
      _appLocale = const Locale("sv");
      await prefs.setString('language_code', 'sv');
      await prefs.setString('countryCode', '');
    } else {
      _appLocale = const Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', '');
    }
    notifyListeners();
  }
}
