// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:jk_photography_manager/model/m_customer.dart';

import '../widget/customer_datatable.dart';
import '../widget/info_card.dart';


class CustomerInfo extends StatelessWidget {
  final MCustomer customer;

  const CustomerInfo(
    this.customer, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      height: totalHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoCard(customer),
          Divider(color: Colors.transparent,),
          Expanded(
            flex: 4,
            child: CustomerDataTable(customer),
          ),
        ],
      ),
    );
  }
}
