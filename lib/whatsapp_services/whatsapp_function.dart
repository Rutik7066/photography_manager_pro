import 'dart:io';

import 'package:puppeteer/puppeteer.dart';

class WhatsappFunction {
  static Future<void> createMessage(
      {required String number, required String message}) async {
    var inputid =
        '#main > footer > div._2BU3P.tm2tP.copyable-area > div > span:nth-child(2) > div > div._2lMWa > div.p3_M1 > div > div.fd365im1.to2l77zo.bbv8nyr4.mwp4sxku.gfz4du6o.ag5g9lrv';
    var url =
        'https://web.whatsapp.com/send/?phone=91$number&text&type=phone_number&app_absent=0';

    var browser = await puppeteer.launch(
      headless:  false,
      defaultViewport: const DeviceViewport(width: 930, height: 620),
      userDataDir: '%userprofile%\\User Data',
      args: [
        '--use-gl=egl',
        '--no-sandbox',
        '--disable-setuid-sandbox',
      ],
    );
   try{
    var page = await browser.newPage();
    await page.goto(url, wait: Until.networkIdle);
    await page.waitForSelector(inputid, timeout: const Duration(seconds: 25));
    await page.type(inputid, '${DateTime.now()}');
    await browser.close();
   }catch(e){
    await browser.close();
   }


  }

// demo() async {
//     print(chromedriver.BrowserPath.chrome);
//     var inputid =
//         '#main > footer > div._2BU3P.tm2tP.copyable-area > div > span:nth-child(2) > div > div._2lMWa > div.p3_M1 > div > div.fd365im1.to2l77zo.bbv8nyr4.mwp4sxku.gfz4du6o.ag5g9lrv';
//     var btnid =
//         '#main > footer > div._2BU3P.tm2tP.copyable-area > div > span:nth-child(2) > div > div._2lMWa > div._3HQNh._1Ae7k > button';
//     var url =
//         'https://web.whatsapp.com/send/?phone=917219656111&text&type=phone_number&app_absent=0';
//     var browser = await chromedriver.puppeteer.launch(
//         headless: false,
//         defaultViewport:
//             const chromedriver.DeviceViewport(width: 930, height: 620),
//         userDataDir: '%userprofile%\\User Data',
//      slowMo: const Duration(microseconds: 1000));
//     var page = await browser.newPage();
//     await page.goto(url, wait: chromedriver.Until.networkIdle);
//     await page.waitForSelector(inputid, timeout: const Duration(seconds: 25));
//     await page.type(inputid, '${DateTime.now()}');
//     await page.waitForSelector(btnid, timeout: const Duration(seconds: 25));
//     await page.click(btnid);
//     print('exicuted');
//   }




}
