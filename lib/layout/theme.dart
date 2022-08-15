import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeSelection extends ChangeNotifier{

  Brightness _currentTheme = Brightness.light;

  
  get currentTheme => _currentTheme;

  bool value  =true; 

  
  toggleTheme(bool v){
    value = v;
    _currentTheme = _currentTheme == Brightness.light ? Brightness.dark:Brightness.light;
    notifyListeners(); 
  }



}