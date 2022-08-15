import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:jk_photography_manager/auth/log_in.dart';
import 'package:jk_photography_manager/auth/m_user.dart';
import 'package:jk_photography_manager/layout/layout.dart';
import 'package:supabase/supabase.dart';

class Auth extends ChangeNotifier {
// Check the user box if we don't get then => Log in page,
// but if we get the value then check the end date is after today or not.
// if the end date is passed then => trail ended.
// if not => continue.....
  final Box _user = Hive.box('knfgirn');

  Widget? _route;
  Widget? get route => _route;
  final _client = SupabaseClient(
    'https://etvlugemxlxtvbhqhksg.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0dmx1Z2VteGx4dHZiaHFoa3NnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTc1NDE4NTgsImV4cCI6MTk3MzExNzg1OH0.wa-fgXbzMqJ2Rwescil_wTdnyl8526iakJoDWzUP8FM',
  );

  check() {
    DateTime? value = _user.get('endDate');
    if (value != null) {
      if (DateTime.now().isBefore(value)) {
        _route = const Layout();
      } else if (DateTime.now().isAfter(value)) {
        _route = const LogIn();
      }
    } else if (value == null) {
      _route = const LogIn();
    }
  }

  tryDemo() {
    _user.putAll({
      'userName': 'Trail',
      'userNumber': '000000000,000000000',
      'userBussinessName': 'Trail version',
      'userBussinessAddress': 'Trail Verison',
      'endDate': DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
      'logo': null,
    });
    check();
   notifyListeners();
  }

  signin({required String email, required String password}) async {
    final r = await _client.auth.signIn(email: email, password: password);
    if (r.error != null) {
      return 1;
    } else if (r.user != null) {
      final image = await _client.storage.from('logo').download('${email}');
      final userData = await _client.from('user').select().eq('email', r.user!.email).execute();
      if (userData.data != null && image.data != null) {
        List l = userData.data as List;
        Map map = l.first;
        map['logo'] = image.data!;
        print(map['endDate']);
        map['endDate'] = DateFormat("yyyy-MM-dd").parse(map['endDate']);
        _user.putAll(map);
      }
      check();
      notifyListeners();
    }
  }

  MUser giveMetheUser() {
    return MUser.fromBox(_user);
  }
}
