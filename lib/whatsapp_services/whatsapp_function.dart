import 'dart:io';

class WhatsappFunction {
  createMessage({required String number, required String message}) async {
    if (number.isNotEmpty && message.isNotEmpty) {
      print('invoked');
      Uri encodedMessage = Uri.parse(message);
      var startWhatsup = await Process.start('cmd', ['']);
      startWhatsup.stdin.writeln('start whatsapp://send?phone=91$number^&text=$encodedMessage');
    }
  }
  // start whatsapp://send/?phone=+917219656111&text=HELLO%20WORLD&

}
