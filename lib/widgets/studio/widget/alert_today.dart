import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:jk_photography_manager/common_widgets/bill_info.dart';
import 'package:jk_photography_manager/common_widgets/event_info.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/controller/quick_bill.dart';
import 'package:jk_photography_manager/model/daily/m_business.dart';
import 'package:jk_photography_manager/model/daily/m_datatable_row.dart';
import 'package:jk_photography_manager/model/daily/m_expense.dart';
import 'package:jk_photography_manager/model/m_bill.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_event.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:jk_photography_manager/widgets/studio/widget/alert_payment_rec.dart';
import 'package:provider/provider.dart';

class AlertToday extends StatefulWidget {
  MBusiness aday;

  AlertToday({required this.aday, Key? key}) : super(key: key);

  @override
  State<AlertToday> createState() => _AlertTodayState();
}

class _AlertTodayState extends State<AlertToday> {
  @override
  Widget build(BuildContext context) {
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    String fdate = DateFormat.yMMMMd('en_US').format(widget.aday.date!);
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        width: MediaQuery.of(context).size.width * 0.80,
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        fdate,
                        style: style.textTheme.headline5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text('Income   \u20B9 ${widget.aday.todayincome}', style: style.textTheme.titleSmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text('Expense   \u20B9 ${widget.aday.todayExpenses}', style: style.textTheme.titleSmall),
                    ),
                  ],
                ),
              ],
            ),
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
                    widget.aday.daily!.length,
                    (index) {
                      MDataTableRow row = widget.aday.daily!.reversed.toList()[index];
                      return DataRow2.byIndex(
                        color: MaterialStateProperty.all(Colors.transparent),
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
                                }
                                else if (row.typename == 'Expense' && row.type is MExpenses) {
                                  MExpenses r = row.type;
                                  return AlertExpense(exp: r);
                                }  else {
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
      ),
      actions: [
        SizedBox(
          height: 30,
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
           
              )),
        )
      ],
    );
  }
}
