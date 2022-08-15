// ignore_for_file: prefer_final_fields

import 'package:hive_flutter/hive_flutter.dart';

class WhatsAppTemplate {
  Box _msgtemp = Hive.box('msgtemp');

  addMsg(String msg, String title) {
    _msgtemp.put(title, msg);
  }
  
  String? retriveMsg(String title) {
    return _msgtemp.get(title);
  }
}
