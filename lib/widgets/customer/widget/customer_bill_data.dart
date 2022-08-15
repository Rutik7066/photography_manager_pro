import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:jk_photography_manager/common_widgets/bill_info.dart';
import 'package:jk_photography_manager/model/m_bill.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:provider/provider.dart';

class CustomerBillData extends StatelessWidget {
  MCustomer customer;
  CustomerBillData(this.customer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MBill> bills = customer.bills ?? [];
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);

    return DataTable2(
      sortAscending: false,
      columns: const [
        DataColumn2(label: Text('No.'), fixedWidth: 100),
        DataColumn2(label: Text('Type')),
        DataColumn2(label: Text('Total')),
        DataColumn2(label: Text('Discount')),
        DataColumn2(label: Text('Final')),
        DataColumn2(label: Text('Unpaid')),
        DataColumn2(label: Text('Status')),
      ],
      rows: List.generate(
        bills.length,
        (index) {
          MBill current = bills[index];
          return DataRow2.byIndex(
                 color: MaterialStateProperty.all(style.canvasColor),
            onDoubleTap: ()async{
              await showDialog(context: context, builder: (context){
                return BillInfo(customer: customer, bill: current);
              });
            },
            index: index,
            cells: [
              DataCell(Text('${current.billindex}')),
              DataCell(Text('${current.type}')),
              DataCell(Text('${current.total}')),
              DataCell(Text('${current.discount}')),
              DataCell(Text('${current.finalTotal}')),
              DataCell(Text('${current.unPaid}')),
              DataCell(
                DropdownButton2(
                  buttonPadding: const EdgeInsets.all(5),
                  buttonHeight: 33,
                  onChanged: (v) {},
                  value: current.status,
                  isDense: true,
                  items: <DropdownMenuItem<int>>[
                    DropdownMenuItem(
                      value: 0,
                      child: Text(
                        'Pending',
                        style: style.textTheme.bodyMedium,
                      ),
                      onTap: () {
                        customerprovider.updateBillStatus(bill: current, statuscode: 0);
                        customerprovider.custmerValueInit(customer);
                      },
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text(
                        'Completed',
                        style: style.textTheme.bodyMedium,
                      ),
                      onTap: () {
                        customerprovider.updateBillStatus(bill: current, statuscode: 1);
                        customerprovider.custmerValueInit(customer);
                      },
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text(
                        'Delivered',
                        style: style.textTheme.bodyMedium,
                      ),
                      onTap: () {
                        customerprovider.updateBillStatus(bill: current, statuscode: 2);
                        customerprovider.custmerValueInit(customer);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
