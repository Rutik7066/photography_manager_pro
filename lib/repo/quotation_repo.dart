import 'package:hive_flutter/hive_flutter.dart';
import 'package:jk_photography_manager/model/m_quotation.dart';

class QuotationRepo {
  Box box = Hive.box('QuotationBox');

  addQuotation({required String name, required String number, required List cart, required int discount}) async {
    int total = 0;
    for (var i in cart) {
      total = total + i['totalprice'] as int;
    }
    int index = await box.add({
      'name': name,
      'number': number,
      'cart': cart,
      'total': total,
      'discount': discount,
      'finalTotal': total - discount,
    });

    return box.getAt(index);
  }

  List<MQuotation> getAllQuotation() {
    List<MQuotation> list = box.values.map((e) {
      return MQuotation.fromMap(e);
    }).toList();
    return list;
  }
}
