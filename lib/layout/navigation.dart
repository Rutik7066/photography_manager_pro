// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jk_photography_manager/page/bill.dart';
import 'package:jk_photography_manager/page/customer.dart';
import 'package:jk_photography_manager/page/event.dart';
import 'package:jk_photography_manager/page/finance.dart';
import 'package:jk_photography_manager/page/setting.dart';
import 'package:jk_photography_manager/page/studio.dart';
import 'package:jk_photography_manager/page/whatsapp.dart';


class Navigation extends ChangeNotifier {
  int selectedIndex = 0;
  Widget _selectedWidget =  Studio();

  get selectedWidget => _selectedWidget;

  void select(int n) {
    selectedIndex = n;
    switch (n) {
      case 0:
        {
          _selectedWidget = const Studio();
        }
        break;
      case 1:
        {
          _selectedWidget = const Event();
        }
        break;
      case 2:
        {
          _selectedWidget = const Bill();
        }
        break;
      case 3:
        {
          _selectedWidget = const Finance();
        }
        break;
      case 4:
        {
          _selectedWidget = const Customer();
        }
        break;
      case 5:
        {
          _selectedWidget = const Whatsapp();
        }
        break;
      case 6:
        {
          _selectedWidget = const Setting();
        }
    }
    notifyListeners();
  }

  void routeAdd(Widget wid) {
    _selectedWidget = wid;
    notifyListeners();
  }
}
