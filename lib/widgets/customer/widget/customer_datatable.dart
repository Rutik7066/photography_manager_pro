// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:jk_photography_manager/model/m_bill.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_event.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:provider/provider.dart';

import 'customer_bill_data.dart';
import 'customer_events_data.dart';

class CustomerDataTable extends StatefulWidget {
  final MCustomer customer;

  const CustomerDataTable(this.customer, {Key? key}) : super(key: key);

  @override
  State<CustomerDataTable> createState() => _CustomerDataTableState();
}

class _CustomerDataTableState extends State<CustomerDataTable> {
  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 400,
            child: TabBar(
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('Bills', style: style.textTheme.bodyLarge),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('Events', style: style.textTheme.bodyLarge),
                )
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomerBillData(widget.customer),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomerEventsData(customer: widget.customer),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
