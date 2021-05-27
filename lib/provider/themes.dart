import 'package:flutter/material.dart';

enum ThemeType {
  light,
  dark,
}

class ThemeChanger with ChangeNotifier {
  ThemeData? _lightThemeData;
  ThemeData? _darkThemeData;

  ThemeType _currTheme = ThemeType.light;

  ThemeChanger() {
    _setThemesDatas();
  }

  _setThemesDatas() {
    _lightThemeData = ThemeData(
      primarySwatch: Colors.blueGrey,
      canvasColor: Colors.grey.shade100,
      accentColor: Colors.grey.shade400,
      cardColor: Colors.blueAccent.shade100,
      accentColorBrightness: Brightness.dark,
      fontFamily: 'Righteous-Regular',
      textTheme: ThemeData.light().textTheme.copyWith(
          headline1: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            fontSize: 36,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          bodyText2: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 0.5)),
    );
    _darkThemeData = ThemeData(
      primarySwatch: Colors.indigo,
      canvasColor: Color(0xFF00183f),
      accentColor: Colors.indigo.shade400,
      accentColorBrightness: Brightness.dark,
      cardColor: Colors.blue.shade800,
      fontFamily: 'Righteous-Regular',
      textTheme: ThemeData.dark().textTheme.copyWith(
          headline1: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            fontSize: 36,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          headline6: TextStyle(color: Colors.black),
          bodyText1: TextStyle(
              fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
          bodyText2: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.5,
              color: Colors.white)),
    );
    notifyListeners();
  }

  ThemeData get themeData {
    if (_currTheme == ThemeType.dark) {
      return _darkThemeData ?? ThemeData();
    }
    return _lightThemeData ?? ThemeData();
  }

  ThemeType get currTheme {
    return _currTheme;
  }

  setTheme(ThemeType theme) {
    this._currTheme = theme;
    notifyListeners();
  }
}
