import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jk_photography_manager/auth/auth.dart';
import 'package:jk_photography_manager/auth/log_in.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/controller/new_event_controller.dart';
import 'package:jk_photography_manager/controller/quick_bill.dart';
import 'package:jk_photography_manager/controller/regular_bill_controller.dart';
import 'package:jk_photography_manager/layout/layout.dart';
import 'package:jk_photography_manager/layout/navigation.dart';
import 'package:jk_photography_manager/layout/theme.dart';
import 'package:jk_photography_manager/model/daily/m_business.dart';
import 'package:jk_photography_manager/model/daily/m_datatable_row.dart';
import 'package:jk_photography_manager/model/m_bill.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_product.dart';
import 'package:jk_photography_manager/provider/business_provider.dart';
import 'package:jk_photography_manager/provider/finance_provider.dart';
import 'package:jk_photography_manager/provider/product_provider.dart';
import 'package:jk_photography_manager/repo/customer_repo.dart';
import 'package:jk_photography_manager/whatsapp_services/whatsapp_provider.dart';
import 'package:provider/provider.dart';
import 'model/daily/m_expense.dart';
import 'model/m_event.dart';
import 'provider/customer_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setMinWindowSize(const Size(1100, 700));
  String path = Directory.current.path;
  Hive.init('db');
  Hive.registerAdapter<MCustomer>(MCustomerAdapter());
  Hive.registerAdapter<MBill>(MBillAdapter());
  Hive.registerAdapter<MEvent>(MEventAdapter());
  Hive.registerAdapter<MProduct>(MProductAdapter());
  Hive.registerAdapter<MDataTableRow>(MDataTableRowAdapter());
  Hive.registerAdapter<MBusiness>(MBusinessAdapter());
  Hive.registerAdapter<MExpenses>(MExpensesAdapter());
  await Hive.openBox<MBusiness>('BusinessBox');
  await Hive.openBox<MCustomer>('CustomerBox');
  await Hive.openBox('FinanceBox');
  await Hive.openBox('QuotationBox');
  await Hive.openBox('knfgirn');
  await Hive.openBox<MProduct>('ProductBox');
  await Hive.openBox('msgtemp');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => Auth(),
      builder: (context, _) {
        var auth = Provider.of<Auth>(context);
        auth.check();
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<Navigation>.value(value: Navigation()),
            ChangeNotifierProvider<CustomerProvider>.value(value: CustomerProvider()),
            ChangeNotifierProvider<RegularBillController>.value(value: RegularBillController()),
            ChangeNotifierProvider<NewEventController>.value(value: NewEventController()),
            ChangeNotifierProvider<QuickBill>.value(value: QuickBill()),
            ChangeNotifierProvider<BusinessProvider>.value(value: BusinessProvider()),
            ChangeNotifierProvider<FinanceProvider>.value(value: FinanceProvider()),
            ChangeNotifierProvider<WhatsappProvider>.value(value: WhatsappProvider()),
            ChangeNotifierProvider<ProductProvider>.value(value: ProductProvider()),
          ],
          child:
              MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              //brightness: Provider.of<ThemeSelection>(context).currentTheme,
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.indigo)),
                  side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.indigoAccent)),
                ),
              ),
            ),
            title: 'Photography Manager',
           home: auth.route ?? const Layout(),
          ),
        );
      },
    );
  }
}
