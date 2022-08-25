import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:hive/hive.dart';
import 'package:win32/win32.dart';

class WhatsappFunction {
  Box box = Hive.box('ExtraNumBox');
  getAllContact (){
    return box.values.toList();
  }

  Future<void> createMessage({required String number, required String message}) async {
    if (number.isNotEmpty && message.isNotEmpty) {
      print('invoked');
      Uri encodedMessage = Uri.parse(message);
      var startWhatsup = await Process.start('cmd', ['']);
      startWhatsup.stdin.writeln('start whatsapp://send?phone=91$number^&text=$encodedMessage');
    }
  }
  // start whatsapp://send/?phone=+917219656111&text=HELLO%20WORLD&

  Future<void> sendMessage({required String number, required String message}) async {
    if (number.isNotEmpty && message.isNotEmpty) {
      const VK_A = 0x0D;
      Uri encodedMessage = Uri.parse(message);
      var startWhatsup = await Process.start('cmd', ['']);
      startWhatsup.stdin.writeln('start whatsapp://send?phone=91$number^&text=$encodedMessage');
      Sleep(2000);
      final kbd = calloc<INPUT>();
      kbd.ref.type = INPUT_KEYBOARD;
      kbd.ref.ki.wVk = VK_A;
      var result = SendInput(1, kbd, sizeOf<INPUT>());
      if (result != TRUE) print('Error: ${GetLastError()}');
      free(kbd);
      box.add(number);
    }
  }
}
