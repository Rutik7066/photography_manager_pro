import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/common_widgets/widget_to_image/bill_to_image.dart';
import 'package:jk_photography_manager/model/m_bill.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/provider/business_provider.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:provider/provider.dart';

class BillInfo extends StatefulWidget {
  MCustomer customer;
  MBill bill;

  BillInfo({
    required this.customer,
    required this.bill,
    Key? key,
  }) : super(key: key);

  @override
  State<BillInfo> createState() => _BillInfoState();
}

class _BillInfoState extends State<BillInfo> {
  String _dropdowninitvalue = 'Cash';

  final TextEditingController _paymentController = TextEditingController();

  GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    List<Map<String, dynamic>> selectedproducts = widget.bill.cart!;
    var today = Provider.of<BusinessProvider>(context);

    return AlertDialog(
      title: Text('Bill Number: ${widget.bill.billindex}'),
      content: SizedBox(
        width: 900,
        height: MediaQuery.of(context).size.height * 0.68,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.customer.name!,
                    style: style.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.customer.number!,
                    style: style.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.customer.address!,
                    style: style.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: DataTable2(
                dataRowHeight: 40,
                headingRowHeight: 40,
                columns: [
                  DataColumn2(
                      label: Text(
                        'Index',
                        style: style.textTheme.bodyLarge,
                      ),
                      fixedWidth: 70),
                  DataColumn2(
                      label: Text(
                        'Product',
                        style: style.textTheme.bodyLarge,
                      ),
                      size: ColumnSize.L),
                  DataColumn2(
                    label: Text(
                      'Price',
                      style: style.textTheme.bodyLarge,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Qty',
                      style: style.textTheme.bodyLarge,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Total',
                      style: style.textTheme.bodyLarge,
                    ),
                  ),
                ],
                rows: List.generate(
                  selectedproducts.length,
                  (index) {
                    Map<String, dynamic> product = selectedproducts[index];
                    return DataRow2(cells: [
                      DataCell(SizedBox(
                          width: 100,
                          child: AutoSizeText(
                            '${index + 1}',
                            style: style.textTheme.bodyMedium,
                          ))),
                      DataCell(AutoSizeText(
                        '${product['product']}',
                        style: style.textTheme.bodyMedium,
                      )),
                      DataCell(AutoSizeText(
                        '${product['price']}',
                        style: style.textTheme.bodyMedium,
                      )),
                      DataCell(AutoSizeText(
                        '${product['qty']}',
                        style: style.textTheme.bodyMedium,
                      )),
                      DataCell(AutoSizeText(
                        '${product['totalprice']}',
                        style: style.textTheme.bodyMedium,
                      )),
                    ]);
                  },
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total:',
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              'Discount:',
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              'Final:',
                              style: style.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bill.total.toString(),
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              widget.bill.discount.toString(),
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              widget.bill.finalTotal.toString(),
                              style: style.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Paid:',
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              'Mode:',
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              'Unpaid:',
                              style: style.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bill.paymentOrAdvance.toString(),
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              widget.bill.paymentHistoryOfBill!.first['mode'],
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              widget.bill.unPaid.toString(),
                              style: style.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 30,
            width: 200,
            child: MyTextField(
              hintText: 'Add Payment',
              controller: _paymentController,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              dropdownPadding: const EdgeInsets.all(2),
              itemHeight: 30,
              dropdownOverButton: true,
              buttonElevation: 5,
              buttonPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              buttonHeight: 30,
              buttonWidth: 120,
              buttonDecoration: BoxDecoration(color: style.cardColor, border: Border.all(color: style.dividerColor), borderRadius: BorderRadius.circular(4)),
              value: _dropdowninitvalue,
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
                setState(() {
                  _dropdowninitvalue = value!;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 30,
            child: OutlinedButton.icon(
                onPressed: () {
                  int? payment = int.tryParse(_paymentController.text);
                  if (payment != null) {
                    customerprovider.addBillPayment(customer: widget.customer, bill: widget.bill, payment: payment, paymentmode: _dropdowninitvalue);
                    today.addRow(category: 'Income', type: widget.bill, typename: 'Payment', context: widget.customer.name!, transaction: payment, paymentmode: _dropdowninitvalue);
                    _paymentController.clear();
                  }
                },
                icon: const Icon(
                  MaterialIcons.add,
                  size: 20,
                ),
                label: const Text(
                  'Add Payment',
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            height: 30,
            child: OutlinedButton.icon(
              onPressed: () async {
                await showDialog(context: context, builder: (context) => BillToImage(bill: widget.bill));
              },
              icon: const Icon(Ionicons.receipt_outline, size: 15),
              label: const Text(
                'Genarate Bill',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
