import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:jk_photography_manager/repo/whatsapptemplate.dart';

class WhatsappApi {
  final Box box = Hive.box('whatsappapi');

  String token = '5a08c224cbcda1310d60de6243c429e4';

  Future<void> addInstanceID(String id) async {
    return box.put('instanceId', id);
  }

// getInstanceId() retrive the instance id from database
  Future<String?> getInstanceId() async {
    return box.get('instanceId');
  }

  Future<String?> sendMsg({String? number}) async {
    String id = await getInstanceId() ?? '';
    String msg = WhatsAppTemplate().retriveMsg('') ?? '';
    Response r = await get(Uri.parse('https://asnbulksender.in/api/send.php?number=$number&type=text&message=$msg&instance_id=$id&access_token=$token'));
    return jsonDecode(r.body);
  }

// Sending the bill.
// Sending GET request with number, msg, image path on local disk, instance id and token.
  Future<String> sendBill({
    required String msg,
    required String number,
    required String path,
    required String fileName
  }) async {
    String id = await getInstanceId() ?? '';
    Response r = await get(Uri.parse('https://asnbulksender.in/api/send.php?number=$number&type=media&message=$msg&media_url=$path&filename=$fileName&instance_id=$id&access_token=$token'));
    print(jsonDecode(r.body));
// jsonDecode it convert responce body into map and print will print it in terminal.
// in responce body getting 
// {
//   'status' : 'error',
//   'message' : "Failed to send the message."
// }

    return jsonDecode(r.body)['status'];
  }
}
