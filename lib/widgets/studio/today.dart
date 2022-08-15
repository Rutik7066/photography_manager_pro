import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:jk_photography_manager/common_widgets/bill_info.dart';
import 'package:jk_photography_manager/common_widgets/event_info.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/common_widgets/new_customer.dart';
import 'package:jk_photography_manager/controller/quick_bill.dart';
import 'package:jk_photography_manager/model/daily/m_datatable_row.dart';
import 'package:jk_photography_manager/model/daily/m_expense.dart';
import 'package:jk_photography_manager/model/m_bill.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_event.dart';
import 'package:jk_photography_manager/model/m_product.dart';
import 'package:jk_photography_manager/provider/business_provider.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:jk_photography_manager/whatsapp_services/whatsapp_function.dart';
import 'package:jk_photography_manager/widgets/studio/widget/alert_payment_rec.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:win32/win32.dart';

import '../../auth/auth.dart';
import '../../auth/m_user.dart';
import '../../provider/product_provider.dart';
import '../../repo/whatsapptemplate.dart';

class Today extends StatefulWidget {
  const Today({Key? key}) : super(key: key);

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  TextEditingController _productController = TextEditingController();

  TextEditingController _customerController = TextEditingController();

  TextEditingController _qtyController = TextEditingController();

  TextEditingController _disController = TextEditingController();

  TextEditingController _payController = TextEditingController();

  String todaydate = DateFormat.yMMMMd('en_US').format(DateTime.now());

  TextEditingController _numberController = TextEditingController();
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    var quickbill = Provider.of<QuickBill>(context);
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    var today = Provider.of<BusinessProvider>(context);
    var productPro = Provider.of<ProductProvider>(context);
    var auth = Provider.of<Auth>(context);
    MUser user = auth.giveMetheUser();
    today.init();

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        todaydate,
                        style: style.textTheme.headline5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text('Income   \u20B9 ${today.todayIncome}', style: style.textTheme.titleSmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text('Expense   \u20B9 ${today.todayExpense}', style: style.textTheme.titleSmall),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 30,
                                width: 400,
                                child: TypeAheadField<MCustomer>(
                                  hideOnEmpty: true,
                                  textFieldConfiguration: TextFieldConfiguration(
                                    style: style.textTheme.bodyMedium,
                                    controller: _customerController,
                                    decoration: InputDecoration(
                                      hintText: 'Customer name',
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      filled: true,
                                      hintStyle: style.textTheme.bodyMedium,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                                      alignLabelWithHint: false,
                                    ),
                                  ),
                                  onSuggestionSelected: (item) {
                                    quickbill.selectedCustomer = item;
                                    quickbill.selectedCustomerName = item.name;
                                    quickbill.selectedCustomerNumber = item.number;
                                    _customerController.text = quickbill.selectedCustomer!.name!;
                                    _numberController.text = quickbill.selectedCustomer!.number!;
                                    setState(() {
                                      isEnabled = false;
                                    });
                                  },
                                  itemBuilder: (BuildContext context, itemData) {
                                    return ListTile(
                                      title: Text(itemData.name!),
                                      trailing: Text(itemData.number!),
                                    );
                                  },
                                  suggestionsCallback: (pattern) {
                                    return customerprovider.getCustomer(pattern);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: 30,
                                  width: 150,
                                  child: MyTextField(
                                    hintText: 'Number',
                                    enabled: isEnabled,
                                    controller: _numberController,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 30,
                                width: 150,
                                child: TypeAheadField<MProduct>(
                                  hideOnEmpty: true,
                                  textFieldConfiguration: TextFieldConfiguration(
                                    style: style.textTheme.bodyMedium,
                                    controller: _productController,
                                    decoration: InputDecoration(
                                      hintText: 'Product Name',
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      filled: true,
                                      hintStyle: style.textTheme.bodyMedium,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                                      alignLabelWithHint: false,
                                    ),
                                  ),
                                  itemBuilder: (BuildContext context, itemData) {
                                    return ListTile(
                                      title: Text(itemData.productname!),
                                      trailing: Text(itemData.price.toString()),
                                    );
                                  },
                                  suggestionsCallback: (String pattern) {
                                    return productPro.getProductForRegularBill(pattern);
                                  },
                                  onSuggestionSelected: (MProduct suggestion) {
                                    quickbill.selctedProduct = suggestion;
                                    _productController.text = quickbill.selctedProduct!.productname!;
                                    quickbill.qty = 1;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 50,
                                height: 30,
                                child: MyTextField(
                                  hintText: 'Qty',
                                  controller: _qtyController,
                                  onChanged: (v) {
                                    int qty = int.tryParse(v) ?? 0;
                                    if (quickbill.selctedProduct != null) {
                                      quickbill.qty = qty;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 30,
                                width: 150,
                                child: MyTextField(
                                  hintText: 'Discount',
                                  controller: _disController,
                                  onChanged: (v) {
                                    int? discount = int.tryParse(v) ?? 0;
                                    if (quickbill.selctedProduct != null && quickbill.total > 0) {
                                      quickbill.discount = discount;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100,
                              child: Text(
                                'Final: ${quickbill.finalP}',
                                style: style.textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 30,
                                width: 150,
                                child: MyTextField(
                                  hintText: 'Payment',
                                  controller: _payController,
                                  onChanged: (v) {
                                    int? p = int.tryParse(v);
                                    quickbill.paid = p;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                dropdownPadding: const EdgeInsets.all(0),
                                itemHeight: 40,
                                dropdownOverButton: true,
                                buttonElevation: 5,
                                buttonPadding: const EdgeInsets.all(5),
                                buttonHeight: 30,
                                buttonWidth: 100,
                                buttonDecoration: BoxDecoration(color: style.cardColor, border: Border.all(color: style.dividerColor), borderRadius: BorderRadius.circular(4)),
                                value: quickbill.paymentmode.toString(),
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'Cash',
                                    child: Text(
                                      'Cash',
                                      style: style.textTheme.bodyMedium,
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'Online',
                                    child: Text('Online', style: style.textTheme.bodyMedium),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  quickbill.paymentmode = value;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 30,
                              width: 100,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  quickbill.selectedCustomerName = _customerController.text;
                                  quickbill.selectedCustomerNumber = _numberController.text;
                                  var r = await quickbill.addbill();
                                  if (r == true) {
                                    today.init();
                                    _customerController.clear();
                                    _productController.clear();
                                    _qtyController.clear();
                                    _disController.clear();
                                    _payController.clear();
                                    _numberController.clear();
                                    quickbill.clear();
                                    customerprovider.resetBills();
                                    setState(() {
                                      isEnabled = true;
                                    });
                                  } else {
                                    final bar = SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      width: MediaQuery.of(context).size.height - 40,
                                      backgroundColor: style.errorColor,
                                      duration: const Duration(seconds: 5),
                                      content: Text(
                                        'Something went wrong. Kindly fill all information correctly',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: style.textTheme.bodyLarge!.fontSize ?? 14,
                                          fontWeight: style.textTheme.bodyLarge!.fontWeight,
                                        ),
                                      ),
                                      action: SnackBarAction(label: 'Ok', textColor: Colors.white, onPressed: () {}),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(bar);
                                  }
                                },
                                icon: const Icon(
                                  MaterialIcons.add,
                                  size: 20,
                                ),
                                label: const Text(
                                  'Add',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(height: 1, color: Theme.of(context).primaryColorLight),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: DataTable2(
                columns: [
                  DataColumn2(label: Text('Category', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Type', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Context', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Transaction', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Payment Mode', style: style.textTheme.bodyLarge)),
                ],
                rows: List.generate(
                  today.row.length,
                  (index) {
                    MDataTableRow row = today.row.reversed.toList()[index];
                    return DataRow2.byIndex(
                      color: MaterialStateProperty.all(style.canvasColor),
                      onDoubleTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              if (row.typename == 'Bill' || row.typename == 'Quick Bill') {
                                MCustomer g = customerprovider.getCustomerByBill(row.type);
                                return BillInfo(customer: g, bill: row.type);
                              } else if (row.typename == 'Event') {
                                MCustomer g = customerprovider.getCustomerByEvent(row.type);
                                return EventInfo(customer: g, event: row.type);
                              } else if (row.typename == 'Payment' && row.type is MBill) {
                                MBill r = row.type;
                                MCustomer g = customerprovider.getCustomerByBill(row.type);
                                return AlertPayment(paymentmode: row.paymentmode!, amt: row.transaction!, billindex: r.billindex!, customerName: row.context!);
                              } else if (row.typename == 'Payment' && row.type is MEvent) {
                                MEvent r = row.type;
                                MCustomer g = customerprovider.getCustomerByEvent(row.type);
                                return AlertPayment(paymentmode: row.paymentmode!, amt: row.transaction!, billindex: r.bill!.billindex!, customerName: row.context!);
                              } else if (row.typename == 'Payment' && row.type is MCustomer) {
                                MCustomer r = row.type;
                                return AlertUnivarsalPayment(paymentmode: row.paymentmode!, amt: row.transaction!, customerName: row.context!);
                              } else if (row.typename == 'Expense' && row.type is MExpenses) {
                                MExpenses r = row.type;
                                return AlertExpense(exp: r);
                              } else {
                                return const AlertDialog();
                              }
                            });
                      },
                      index: index,
                      cells: [
                        DataCell(Text('${row.category}')),
                        DataCell(Text('${row.typename}')),
                        DataCell(Text('${row.context}')),
                        DataCell(Text('${row.transaction}')),
                        DataCell(Text('${row.paymentmode}')),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
