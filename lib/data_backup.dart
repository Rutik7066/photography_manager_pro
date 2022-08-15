import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';

import 'model/daily/m_business.dart';
import 'model/m_customer.dart';
import 'model/m_product.dart';

class Data {
  Future<int> backup(String path) async {
    try {
      String? i = Hive.box<MBusiness>('BusinessBox').path;
      await Hive.box<MBusiness>('BusinessBox').close();
      await File(i!).copy('$path/businessbox');
      String? c = Hive.box<MCustomer>('CustomerBox').path;
      await Hive.box<MCustomer>('CustomerBox').close();
      await File(c!).copy('$path/customerbox');
      String? f = Hive.box('FinanceBox').path;
      await Hive.box('FinanceBox').close();
      await File(f!).copy('$path/financebox');
      String? k = Hive.box('knfgirn').path;
      await Hive.box('knfgirn').close();
      await File(k!).copy('$path/knfgirn');
      String? p = Hive.box<MProduct>('ProductBox').path;
      await Hive.box<MProduct>('ProductBox').close();
      await File(p!).copy('$path/productbox');
      String? m = Hive.box('msgtemp').path;
      await Hive.box('msgtemp').close();
      await File(m!).copy('$path/msgtemp');
      return 0;
    } catch (e) {
      return 1;
    } finally {
      await Hive.openBox<MBusiness>('BusinessBox');
      await Hive.openBox<MCustomer>('CustomerBox');
      await Hive.openBox('FinanceBox');
      await Hive.openBox('knfgirn');
      await Hive.openBox<MProduct>('ProductBox');
      await Hive.openBox('msgtemp');
    }
  }

  Future<int> restore(String path) async {
    try {
      String? i = Hive.box<MBusiness>('BusinessBox').path;
      await Hive.box<MBusiness>('BusinessBox').close();
      await File('$path/businessbox').copy(i!);
      String? c = Hive.box<MCustomer>('CustomerBox').path;
      await Hive.box<MCustomer>('CustomerBox').close();
      await File('$path/customerbox').copy(c!);
      String? f = Hive.box('FinanceBox').path;
      await Hive.box('FinanceBox').close();
      await File('$path/financebox').copy(f!);
      String? k = Hive.box('knfgirn').path;
      await Hive.box('knfgirn').close();
      await File('$path/knfgirn').copy(k!);
      String? p = Hive.box<MProduct>('ProductBox').path;
      await Hive.box<MProduct>('ProductBox').close();
      await File('$path/productbox').copy(p!);
      String? m = Hive.box('msgtemp').path;
      await Hive.box('msgtemp').close();
      await File('$path/msgtemp').copy(m!);
      return 0;
    } catch (e) {
      return 1;
    } finally {
      await Hive.openBox<MBusiness>('BusinessBox');
      await Hive.openBox<MCustomer>('CustomerBox');
      await Hive.openBox('FinanceBox');
      await Hive.openBox('knfgirn');
      await Hive.openBox<MProduct>('ProductBox');
      await Hive.openBox('msgtemp');
    }
  }
}
