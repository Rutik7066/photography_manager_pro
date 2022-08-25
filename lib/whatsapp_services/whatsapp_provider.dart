import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_event.dart';
import 'package:jk_photography_manager/repo/customer_repo.dart';
import 'package:jk_photography_manager/whatsapp_services/whatsapp_function.dart';
import 'package:puppeteer/puppeteer.dart';

// import 'package:csv/csv.dart';
class WhatsappProvider extends ChangeNotifier {
  final _customerrepo = CustomerRepo();

  List<Map<String, dynamic>> getPreviousEvent() {
    List<MEvent> celebrations = _customerrepo.getAllEvents().where((ev) => ev.date == DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day)).toList();
    return celebrations.map((ev) {
      MCustomer customer = _customerrepo.getCustomerByEvent(ev);
      Map<String, dynamic> map = {
        'c': customer,
        'e': ev,
      };
      return map;
    }).toList();
  }

  List<MCustomer> getRecoveryList() {
    return _customerrepo.getallCustomers().where((c) => c.totalRecoveryAmount! > 200).toList();
  }

  ///////////

  List<Map<String, dynamic>> _attachmentList = [];
  List<Map<String, dynamic>> get attachmentList => _attachmentList;
  List<Map<String, dynamic>> _msglog = [];
  List<Map<String, dynamic>> get msglog => _msglog;

  pickfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      for (var img in result.files) {
        Map<String, dynamic> map = {
          'path': img.path.toString(),
          'name': img.name.toString(),
        };
        _attachmentList.add(map);
      }
    }
    notifyListeners();
  }

  removefile(int index) {
    _attachmentList.removeAt(index);
    notifyListeners();
  }

  Future attactmentCampiagn(String? msg) async {
    List<MCustomer> customerList = CustomerRepo().getallCustomers();
    var inputid = '#main > footer > div._2BU3P.tm2tP.copyable-area > div > span:nth-child(2) > div > div._2lMWa > div.p3_M1 > div > div.fd365im1.to2l77zo.bbv8nyr4.mwp4sxku.gfz4du6o.ag5g9lrv';
    var attach = '#main > footer > div._2BU3P.tm2tP.copyable-area > div > span:nth-child(2) > div > div._3HQNh._1un-p > div._2jitM > div';

    var photoVideo = '#main > footer > div._2BU3P.tm2tP.copyable-area > div > span:nth-child(2) > div > div._3HQNh._1un-p > div._2jitM > div > span > div > div > ul > li:nth-child(1) > button > input[type=file]';

    var photoVideoSend = '#app > div > div > div._3ArsE > div.ldL67._3sh5K > span > div > span > div > div > div.KPJpj._2M_x0 > div > div._1HI4Y > div._33pCO > div > div';
    var delevired = '#main > div._2gzeB > div > div._33LGR > div._3K4-L > div:nth-child(5) > div > div.Nm1g1._22AX6 > div.cm280p3y.kbtdaxqp.ocd2b0bc.folpon7g.aa0kojfi.snweb893.g0rxnol2.jnl3jror > div > div.dpkuihx7.lhggkp7q.j2mzdvlq.b9fczbqn > div > div > span';

    var browser = await puppeteer.launch(
      headless: false,
      defaultViewport: const DeviceViewport(width: 930, height: 620),
      userDataDir: '%userprofile%\\User Data',
      args: [
        '--use-gl=egl',
        '--no-sandbox',
        '--disable-setuid-sandbox',
      ],
    );
    List<File> imagelist = _attachmentList.map((e) {
      return File(e['path']);
    }).toList();
List<Map<String, String>> contact = [];
    customerList.forEach((element) {
      contact.add({
        'name': element.name.toString(),
        'number': element.number.toString(),
      });
    });
    List<String> extraContact = WhatsappFunction().getAllContact();
    extraContact.forEach((element) {
      contact.add({
        'name': 'ExtraAddedNumber',
        'number': element,
      });
    });

    for (var customer in contact) {
      var page = await browser.newPage();
      await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3641.0 Safari/537.36');
  String number = customer['number'].toString();
      String name = customer['name'].toString();

      try {
        var url = 'https://web.whatsapp.com/send/?phone=91${number}&text&type=phone_number&app_absent=0';
        await page.goto(url, wait: Until.networkIdle);
        await page.waitForSelector(inputid, timeout: const Duration(seconds: 25));
        await page.type(inputid, msg ?? '');
        await page.click(attach);
        var img = await page.$(photoVideo);
        await img.uploadFile(imagelist);
        await page.waitForSelector(photoVideoSend);
        await page.click(photoVideoSend);
        await page.waitForSelector(delevired);
        await Future.delayed(const Duration(seconds: 5));
        await page.close();
        _msglog.add({'name': name, 'number': number, 'status': 'Successful'});
      } catch (e) {
        _msglog.add({'name': name, 'number': number, 'status': 'Failed'});
        await page.close();
      }
    }
    await browser.close();
  }

  Future messageCampaign(String? msg) async {
    List<MCustomer> customerList = CustomerRepo().getallCustomers();
    var inputid = '#main > footer > div._2BU3P.tm2tP.copyable-area > div > span:nth-child(2) > div > div._2lMWa > div.p3_M1 > div > div.fd365im1.to2l77zo.bbv8nyr4.mwp4sxku.gfz4du6o.ag5g9lrv';
    var delevired = '#main > div._2gzeB > div > div._33LGR > div._3K4-L > div:nth-child(5) > div > div.Nm1g1._22AX6 > div.cm280p3y.kbtdaxqp.ocd2b0bc.folpon7g.aa0kojfi.snweb893.g0rxnol2.jnl3jror > div > div.dpkuihx7.lhggkp7q.j2mzdvlq.b9fczbqn > div > div > span';
    var enter = '#main > footer > div._2BU3P.tm2tP.copyable-area > div > span:nth-child(2) > div > div._2lMWa > div._3HQNh._1Ae7k > button > span';
    var browser = await puppeteer.launch(
      headless: false,
      defaultViewport: const DeviceViewport(width: 930, height: 620),
      userDataDir: '%userprofile%\\User Data',
      args: [
        '--use-gl=egl',
        '--no-sandbox',
        '--disable-setuid-sandbox',
      ],
    );
    List<File> imagelist = _attachmentList.map((e) {
      return File(e['path']);
    }).toList();
    List<Map<String, String>> contact = [];
    customerList.forEach((element) {
      contact.add({
        'name': element.name.toString(),
        'number': element.number.toString(),
      });
    });
    List<String> extraContact = WhatsappFunction().getAllContact();
    extraContact.forEach((element) {
      contact.add({
        'name': 'ExtraAddedNumber',
        'number': element,
      });
    });

    for (var customer in contact) {
      var page = await browser.newPage();
      await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3641.0 Safari/537.36');
      String number = customer['number'].toString();
      String name = customer['name'].toString();

      try {
        var url = 'https://web.whatsapp.com/send/?phone=91${customer}&text&type=phone_number&app_absent=0';
        await page.goto(url, wait: Until.networkIdle);
        await page.waitForSelector(inputid, timeout: const Duration(seconds: 25));
        await page.type(inputid, msg.toString());
        await page.waitForSelector(enter);
        await page.click(enter);
        await page.waitForSelector(delevired);
        await Future.delayed(const Duration(seconds: 2));
        await page.close();
        _msglog.add({'name': name, 'number': number, 'status': 'Successful'});
      } catch (e) {
        _msglog.add({'name': name, 'number': number, 'status': 'Failed'});
        await page.close();
      }
    }
    await browser.close();
  }

  Future rutCampign(String? msg) async {
    if (_attachmentList.isNotEmpty) {
      await attactmentCampiagn(msg);
    } else if (_attachmentList.isEmpty && msg != null) {
      await messageCampaign(msg);
    }
  }

  Future login() async {
    var browser = await puppeteer.launch(
      headless: false,
      defaultViewport: const DeviceViewport(width: 930, height: 620),
      userDataDir: '%userprofile%\\User Data',
      args: [
        '--use-gl=egl',
        '--no-sandbox',
        '--disable-setuid-sandbox',
      ],
    );
    var page = await browser.newPage();
    await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3641.0 Safari/537.36');
    await page.goto('https://web.whatsapp.com', wait: Until.networkIdle, timeout: const Duration(seconds: 300));
  }

  exportlog(String path) {
    var i = 0;
    List<List<String>> preparedlog = _msglog.map((e) {
      i++;
      List<String> list = [i.toString(), e['name'], e['number'], e['status']];
      return list;
    }).toList();
    List<List<String>> csvdataList = [
      ['No', 'Name', 'Number', 'Status'],
      ...preparedlog
    ];
    // String csvData = ListToCsvConverter().convert(csvdataList);
    //   File file = File(path);
    //    file.writeAsStringSync(csvdata);
  }
}
