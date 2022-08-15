import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:jk_photography_manager/common_widgets/event_info.dart';
import 'package:jk_photography_manager/model/m_bill.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_event.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:provider/provider.dart';

class CustomerEventsData extends StatefulWidget {
  MCustomer customer;
  CustomerEventsData({required this.customer, Key? key}) : super(key: key);

  @override
  State<CustomerEventsData> createState() => _CustomerEventsDataState();
}

class _CustomerEventsDataState extends State<CustomerEventsData> {
  @override
  Widget build(BuildContext context) {
    List<MEvent> events = widget.customer.events ?? [];
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    bool i= false; 
    return DataTable2(
      columns: const [
        DataColumn2(label: Text('No.'), size: ColumnSize.S),
        DataColumn2(label: Text('Event'), size: ColumnSize.L),
        DataColumn2(label: Text('Date')),
        DataColumn2(label: Text('Final')),
        DataColumn2(label: Text('Unpaid')),
        DataColumn2(label: Text('Delivered')),
      ],
      rows: List.generate(
        events.length,
        (index) {
          MEvent current = events[index];
          MBill bill = current.bill!;
          String date = '${current.date!.day}/${current.date!.month}/${current.date!.year}';
          return DataRow2.byIndex(
            color: MaterialStateProperty.all(style.canvasColor),
            onDoubleTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return EventInfo(customer: widget.customer, event: current);
                  });
                  setState(() {
                    
                  });
            },
            index: index,
            cells: [
              DataCell(Text(bill.billindex.toString())),
              DataCell(Text('${current.name}')),
              DataCell(Text(date)),
              DataCell(Text('${bill.finalTotal}')),
              DataCell(Text('${bill.unPaid}')),
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
                        customerprovider.updateEventStatus(event: current, statuscode: 0);
                        customerprovider.custmerValueInit(widget.customer);
                      },
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text(
                        'Completed',
                        style: style.textTheme.bodyMedium,
                      ),
                      onTap: () {
                        customerprovider.updateEventStatus(event: current, statuscode: 1);
                        customerprovider.custmerValueInit(widget.customer);
                      },
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text(
                        'Delivered',
                        style: style.textTheme.bodyMedium,
                      ),
                      onTap: () {
                        customerprovider.updateEventStatus(event: current, statuscode: 2);
                        customerprovider.custmerValueInit(widget.customer);
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
