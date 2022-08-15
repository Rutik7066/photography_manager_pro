// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/provider/business_provider.dart';
import 'package:jk_photography_manager/widgets/customer/screens/customer_edit.dart';
import 'package:provider/provider.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import '../../../../layout/navigation.dart';
import '../../../../provider/customer_provider.dart';

/*
InfoCard contains info about customer
1. Name
2. Number
3. Whatsapp reffernce name
4. Address
5. Total of events
6. Total of bill amount (given bussines)
7. Total of pending work  
8. Total of recovary amount
*/

class InfoCard extends StatefulWidget {
  final MCustomer customer;

  const InfoCard(this.customer, {Key? key}) : super(key: key);

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    var navigation = Provider.of<Navigation>(context);
    //  var today = Provider.of<Business>(context);
    var customerProvider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    customerProvider.verifiyCustomerValue(widget.customer);
    customerProvider.getValue(widget.customer);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            color: Colors.transparent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Ionicons.person_outline, size: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${widget.customer.name} (${widget.customer.nickname})',
                          style: style.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(AntDesign.phone, size: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.customer.number!,
                          style: style.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Ionicons.location_outline, size: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: AutoSizeText(
                            widget.customer.address!,
                            maxLines: 4,
                            style: style.textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Flexible(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PopupMenuButton(
                          iconSize: 20,
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                child: Text(
                                  'Edit Customer',
                                  style: style.textTheme.bodyMedium,
                                ),
                                onTap: () {
                                  navigation.routeAdd(CustomerEdit(customer: widget.customer));
                                },
                              ),
                                  PopupMenuItem(
                                child: Text(
                                  'Add Payment',
                                  style: style.textTheme.bodyMedium,
                                ),
                                onTap: () async {
                                  Future.delayed(
                                    const Duration(seconds: 0),
                                    () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AddPaymentDialog(customer: widget.customer);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Info(
                              title: 'Pending Work',
                              value: customerProvider.customerPendingWork.toString(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Info(
                              title: 'Completed Work',
                              value: customerProvider.customerCompletedWork.toString(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Info(
                              title: 'Delivered Work',
                              value: customerProvider.customerDeliveredWork.toString(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Info(
                              title: 'Unpaid Amount',
                              value: '${widget.customer.totalRecoveryAmount ?? 0}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  String title;
  String value;
  Info({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              value,
              style: style.textTheme.headline6,
            ),
            Text(
              title,
            ),
          ],
        ),
      ),
    );
  }
}

class AddPaymentDialog extends StatefulWidget {
  MCustomer customer;
  AddPaymentDialog({required this.customer, Key? key}) : super(key: key);

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  String _dropdowninitvalue = 'Cash';
  final TextEditingController _paymentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var customerProvider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);

    var today = Provider.of<BusinessProvider>(context);

    return AlertDialog(
      title: const Text('Add Payment'),
      content: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Payment can not be greater than\nPending Payment of the Customer', style: TextStyle(color: Colors.red)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 250,
                child: MyTextField(hintText: 'Payment', controller: _paymentController),
              ),
            ),
            SizedBox(
              width: 250,
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
          ],
        ),
      ),
      actions: [
        SizedBox(
          height: 30,
          child: OutlinedButton.icon(
            onPressed: () {
              int? payment = int.tryParse(_paymentController.text);
              if (payment != null && payment <= widget.customer.totalRecoveryAmount!) {
                customerProvider.addPaymentToCustomer(customer: widget.customer, payment: payment, paymentmode: _dropdowninitvalue);
                today.addRow(paymentmode: _dropdowninitvalue, category: 'Income', type: widget.customer, typename: 'Payment', context: widget.customer.name!, transaction: payment);
                Navigator.pop(context);
              }
              _paymentController.clear();
            },
            icon: const Icon(Icons.add, size: 20),
            label: Text('Add', style: style.textTheme.bodyLarge),
          ),
        ),
        SizedBox(
          height: 30,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: style.textTheme.bodyLarge),
          ),
        ),
      ],
    );
  }
}
