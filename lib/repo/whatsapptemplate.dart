// ignore_for_file: prefer_final_fields

import 'package:hive_flutter/hive_flutter.dart';

class WhatsAppTemplate {
  Box _msgtemp = Hive.box('msgtemp');

  Future<void> addMsg(String title, String msg) {
    return _msgtemp.put('template', msg);
  }

  String? retriveMsg(String title) {
    return _msgtemp.get('template');
  }
}
