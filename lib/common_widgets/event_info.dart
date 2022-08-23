import 'dart:io';
import 'dart:typed_data';

import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_event.dart';
import 'package:jk_photography_manager/provider/business_provider.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:provider/provider.dart';
import 'package:widget_to_image/widget_to_image.dart';

import 'my_textfield.dart';      
import 'widget_to_image/bill_to_image.dart';

class EventInfo extends StatefulWidget {
  MCustomer customer;
  MEvent event;

  EventInfo({required this.customer, required this.event, Key? key}) : super(key: key);

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  String _dropdowninitvalue = 'Cash';
  final TextEditingController _paymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.68;
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    List<Map<String, dynamic>> selectedproducts = widget.event.bill!.cart!;
    var today = Provider.of<BusinessProvider>(context);

    return AlertDialog(
      title: const Text('Event'),
      content: SizedBox(
        width: 900,
        height: height,
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            widget.event.name!,
                            style: style.textTheme.bodyLarge,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '${widget.event.date!.day}/${widget.event.date!.month}/${widget.event.date!.year} ${widget.event.time}',
                            style: style.textTheme.bodyLarge,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            width: 900 / 2 - 100,
                            child: Text(
                              widget.event.description!,
                              style: style.textTheme.bodyLarge,
                              softWrap: true,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      child: DataTable2(
                        headingRowHeight: 30,
                        showBottomBorder: true,
                        columns: [
                          DataColumn2(label: Text('Product', style: style.textTheme.bodyLarge), size: ColumnSize.L),
                          DataColumn2(label: Text('Price', style: style.textTheme.bodyLarge), size: ColumnSize.M),
                          DataColumn2(label: Text('Qty', style: style.textTheme.bodyLarge), size: ColumnSize.S),
                          DataColumn2(label: Text('Total', style: style.textTheme.bodyLarge), size: ColumnSize.M),
                        ],
                        rows: List.generate(
                          selectedproducts.length,
                          (index) {
                            Map<String, dynamic> product = selectedproducts[index];
                            List<String> des = product['Description'];
                            return DataRow2.byIndex(
                              index: index,
                              specificRowHeight: (des.length * style.textTheme.bodyLarge!.fontSize!) + style.textTheme.bodyMedium!.fontSize! + 35,
                              cells: [
                                DataCell(Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(product['product'], style: style.textTheme.bodyMedium),
                                      if (des.isNotEmpty)
                                        ListView(
                                          shrinkWrap: true,
                                          children: List.generate(
                                              des.length,
                                              (index) => Text(
                                                    des[index],
                                                    style: style.textTheme.bodySmall,
                                                  ),
                                              growable: false),
                                        )
                                    ],
                                  ),
                                )),
                                DataCell(Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(children: [Text(product['price'].toString(), style: style.textTheme.bodyMedium)]),
                                )),
                                DataCell(Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(children: [Text(product['qty'].toString(), style: style.textTheme.bodyMedium)]),
                                )),
                                DataCell(Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(children: [Text(product['totalprice'].toString(), style: style.textTheme.bodyMedium)]),
                                )),
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
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              widget.event.bill!.total.toString(),
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              widget.event.bill!.discount.toString(),
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              widget.event.bill!.finalTotal.toString(),
                              style: style.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(),
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
                              widget.event.bill!.paymentOrAdvance.toString(),
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              widget.event.bill!.paymentHistoryOfBill!.first['mode'],
                              style: style.textTheme.bodyLarge,
                            ),
                            Text(
                              widget.event.bill!.unPaid.toString(),
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
                    customerprovider.addBillPayment(customer: widget.customer, bill: widget.event.bill!, payment: payment, paymentmode: _dropdowninitvalue);
                    today.addRow(category: 'Income', type: widget.event, typename: 'Payment', context: widget.customer.name!, transaction: payment, paymentmode: _dropdowninitvalue);

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
                await showDialog(context: context, builder: (context) => BillToImage(bill: widget.event.bill!));
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
