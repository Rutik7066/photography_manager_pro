import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_event.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:jk_photography_manager/common_widgets/event_info.dart';
import 'package:provider/provider.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({Key? key}) : super(key: key);

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  int _chipNum = 0;

  String _selectedDate = 'Date';

  @override
  Widget build(BuildContext context) {
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    List<MEvent> eventlist = customerprovider.allevents.reversed.toList();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    elevation: 0,
                    pressElevation: 0,
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.all(8),
                    label: const Text(
                      'All Events',
                    ),
                    onSelected: (b) {
                      setState(() {
                        _chipNum = 0;
                      });
                      customerprovider.resetEvents();
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
                    label: const Text('Upcomming Events'),
                    onSelected: (b) {
                      setState(() {
                        _chipNum = 1;
                      });
                      customerprovider.upCommingEvents();
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
                    label: const Text('Old Events'),
                    onSelected: (b) {
                      setState(() {
                        _chipNum = 2;
                      });
                      customerprovider.oldEvents();
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
                    label: Text(_selectedDate),
                    onSelected: (b) async {
                      DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                      if (date != null) {
                        String datef = '${date.day}/${date.month}/${date.year}';
                        _chipNum = 3;
                        _selectedDate = datef;
                        customerprovider.searchEvents(date);
                      }
                    },
                    selected: _chipNum == 3,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: DataTable2(
                columns: const [
                  DataColumn2(label: Text('No.'), size: ColumnSize.S),
                  DataColumn2(label: Text('Customer'), size: ColumnSize.L),
                  DataColumn2(label: Text('Date'), size: ColumnSize.M),
                  DataColumn2(label: Text('Event')),
                  DataColumn2(label: Text('Final')),
                  DataColumn2(label: Text('Unpaid')),
                  DataColumn2(label: Text('Status')),
                ],
                rows: List.generate(
                  eventlist.length,
                  (index) {
                    MEvent event = eventlist[index];
                    String date = '${event.date?.day}/${event.date?.month}/${event.date?.year}';
                    return DataRow2.byIndex(
                           color: MaterialStateProperty.all(style.canvasColor),
                      index: index,
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text('${event.customername}')),
                        DataCell(Text(date)),
                        DataCell(Text('${event.name}')),
                        DataCell(Text('${event.bill!.finalTotal}')),
                        DataCell(Text('${event.bill!.unPaid}')),
                        DataCell(
                          DropdownButton2(
                            buttonPadding: const EdgeInsets.all(5),
                            buttonHeight: 33,
                            isDense: true,
                            value: event.bill?.status,
                            items: <DropdownMenuItem<int>>[
                              DropdownMenuItem(
                                value: 0,
                                child: Text(
                                  'Pending',
                                  style: style.textTheme.bodyMedium,
                                ),
                                onTap: () {
                                  customerprovider.updateEventStatus(event: event, statuscode: 0);
                                },
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                  'Completed',
                                  style: style.textTheme.bodyMedium,
                                ),
                                onTap: () {
                                  customerprovider.updateEventStatus(event: event, statuscode: 1);
                                },
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text(
                                  'Delivered',
                                  style: style.textTheme.bodyMedium,
                                ),
                                onTap: () {
                                  customerprovider.updateEventStatus(event: event, statuscode: 2);
                                },
                              ),
                            ],
                            onChanged: (Object? value) {},
                          ),
                        ),
                      ],
                      onDoubleTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            MCustomer customer = customerprovider.getCustomerByEvent(event);
                            return EventInfo(customer: customer, event: event);
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
