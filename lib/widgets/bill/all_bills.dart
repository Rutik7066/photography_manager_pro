import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/common_widgets/bill_info.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/model/m_bill.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/business_provider.dart';

class AllBills extends StatefulWidget {
  const AllBills({Key? key}) : super(key: key);

  @override
  State<AllBills> createState() => _AllBillsState();
}

class _AllBillsState extends State<AllBills> {
  int _chipNum = 3;


  @override
  Widget build(BuildContext context) {
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    var today = Provider.of<BusinessProvider>(context);
    List<MBill> billlist = customerprovider.allbill;
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 33,
                  width: 200,
                  child: MyTextField(
                    onChanged: (v) {
                      int? index = int.tryParse(v);
                      if (index != null) {
                        customerprovider.searchBill(index);
                      }
                    },
                    hintText: 'Bill number',
                    prefix: const Icon(MaterialIcons.search),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChoiceChip(
                  elevation: 0,
                  pressElevation: 0,
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                  label: const Text('Pending'),
                  onSelected: (b) {
                    customerprovider.getPendingBills();
                    setState(() {
                      _chipNum = 0;
                    });
                  },
                  selected: _chipNum == 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChoiceChip(
                  elevation: 0,
                  pressElevation: 0,
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                  label: const Text('Completed'),
                  onSelected: (b) {
                    customerprovider.getCompletedBills();
                    setState(() {
                      _chipNum = 1;
                    });
                  },
                  selected: _chipNum == 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChoiceChip(
                  elevation: 0,
                  pressElevation: 0,
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                  label: const Text('Delivered'),
                  onSelected: (b) {
                    customerprovider.getDeliveredBills();
                    setState(() {
                      _chipNum = 2;
                    });
                  },
                  selected: _chipNum == 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChoiceChip(
                  elevation: 0,
                  pressElevation: 0,
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                  label: const Text('All'),
                  onSelected: (b) {
                    customerprovider.getAllBills();
                    setState(() {
                      _chipNum = 3;
                    });
                  },
                  selected: _chipNum == 3,
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: DataTable2(
                columns: const [
                  DataColumn2(label: Text('No.'), size: ColumnSize.S),
                  DataColumn2(label: Text('Customer'), size: ColumnSize.L),
                  DataColumn2(label: Text('Total')),
                  DataColumn2(label: Text('Discount')),
                  DataColumn2(label: Text('Final')),
                  DataColumn2(label: Text('Unpaid')),
                  DataColumn2(label: Text('Status')),
                ],
                rows: List.generate(
                  billlist.length,
                  (index) {
                    MBill bill = billlist[index];
                    return DataRow2.byIndex(
                           color: MaterialStateProperty.all(style.canvasColor),
                      index: index,
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text(bill.customername.toString())),
                        DataCell(Text(bill.total.toString())),
                        DataCell(Text(bill.discount.toString())),
                        DataCell(Text(bill.finalTotal.toString())),
                        DataCell(Text(bill.unPaid.toString())),
                        DataCell(
                          DropdownButton2(
                            buttonPadding: const EdgeInsets.all(5),
                            buttonHeight: 33,
                            onChanged: (v) {},
                            value: bill.status,
                            isDense: true,
                            items: <DropdownMenuItem<int>>[
                              DropdownMenuItem(
                                value: 0,
                                child: Text(
                                  'Pending',
                                  style: style.textTheme.bodyMedium,
                                ),
                                onTap: () {
                                  customerprovider.updateBillStatus(bill: bill, statuscode: 0);
                                },
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                  'Completed',
                                  style: style.textTheme.bodyMedium,
                                ),
                                onTap: () {
                                  customerprovider.updateBillStatus(bill: bill, statuscode: 1);
                                },
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text(
                                  'Delivered',
                                  style: style.textTheme.bodyMedium,
                                ),
                                onTap: () {
                                  customerprovider.updateBillStatus(bill: bill, statuscode: 2);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      onDoubleTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            MCustomer thiscustomer = customerprovider.getCustomerByBill(bill);
                            return BillInfo(customer: thiscustomer, bill: bill);
                          },
                        );
                      },
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
