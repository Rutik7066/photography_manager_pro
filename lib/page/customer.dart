// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/common_widgets/my_icon_button.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/whatsapp_services/whatsapp_function.dart';
import 'package:jk_photography_manager/widgets/customer/screens/customer_add.dart';
import 'package:jk_photography_manager/widgets/customer/screens/customer_info.dart';
import 'package:provider/provider.dart';

import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';


import '../layout/navigation.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  final ScrollController _controller = ScrollController();

  TextEditingController _textSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var navigation = Provider.of<Navigation>(context);
    var customerProvider = Provider.of<CustomerProvider>(context);
    List<MCustomer> customers = customerProvider.listofCustomers;
    var style = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Customer',
                  style: style.textTheme.headline5,
                ),
                Spacer(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width / 3,
                  child: MyTextField(
                    prefix: Icon(Icons.search_outlined),
                    controller: _textSearchController,
                    onChanged: (String text) {
                      customerProvider.searchCustomer(text);
                    }, hintText: 'Customer Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 10),
                child: SizedBox(
                  height: 30,
                  child: OutlinedButton.icon(
                      onPressed: () {
                        navigation.routeAdd(CustomerAdd());
                      },
                      icon: Icon(MaterialIcons.person_add_alt_1,size: 20,),
                      label: Text(
                        'New Cutomer',
                      )),
                ),
              )
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: DataTable2(
                showBottomBorder: true,
                scrollController: _controller,
                columns: [
                  DataColumn2(label: Text('Index'), fixedWidth: 100),
                  DataColumn2(label: Text('Customer Name')),
                  DataColumn2(label: Text('Whatsapp Name')),
                  DataColumn2(label: Text('Pending Payment')),
                  DataColumn2(label: Text('Reciept')),
                ],
                rows: List.generate(
                  customers.length,
                  (index) {
                    MCustomer customer = customers[index];
                    int recovery = customer.totalRecoveryAmount ?? 0;
                    return DataRow2.byIndex(
                      color: MaterialStateProperty.all(style.canvasColor),
                      index: index,
                      onDoubleTap: () {
                        navigation.routeAdd(CustomerInfo(customer));
                      },
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text(customer.name!)),
                        DataCell(Text(customer.nickname!)),
                        DataCell(Text(recovery.toString())),
                        DataCell(
                          MyIconButton(
                            iconData: FontAwesome.send,
                            iconSize: 13,
                            onPressed: () async {
                              String message =
                                  'Hi ${customer.nickname}.\nWe are here to inform you that\nyour payment of \u20A8 ${customer.totalRecoveryAmount} is still pending. Kindly pay as soon as possible.\nTo get more information about this kindly visit the studio.';
                              await WhatsappFunction.createMessage(number: customer.number.toString(), message: message);
                            },
                          ),
                        ),
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
