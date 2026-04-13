
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cach/appSharedPreferences.dart';


class ThemeProvider extends ChangeNotifier{
  ThemeMode _themeMode = ThemeMode.system;
  get getTheme => _themeMode;
  set setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
  bool get isDarkMode =>(_themeMode == ThemeMode.dark);


  AppSharedPreferences appSettingsPreferences = AppSharedPreferences.getInstance();
  ThemeProvider(){
    _themeMode = appSettingsPreferences.getCurrentTheme();
  }
  List <ThemeMode>  getModes(){
    return [
      ThemeMode.light,
    ThemeMode.dark,
    ];
  }
  ThemeMode getSelectedThemeMode(){
    return _themeMode;
  }

  void changeTheme(ThemeMode newtheme){
    _themeMode = newtheme;
    appSettingsPreferences.saveTheme(_themeMode);
    notifyListeners();

  }
}