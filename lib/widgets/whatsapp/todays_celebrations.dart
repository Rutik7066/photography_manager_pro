import 'dart:ffi';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:jk_photography_manager/common_widgets/my_icon_button.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_event.dart';
import 'package:jk_photography_manager/whatsapp_services/whatsapp_function.dart';
import 'package:jk_photography_manager/whatsapp_services/whatsapp_provider.dart';
import 'package:provider/provider.dart';
import 'package:win32/win32.dart';

class TodaysCelebrations extends StatelessWidget {
  const TodaysCelebrations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    var whatsappProvider = Provider.of<WhatsappProvider>(context);
    List<Map<String, dynamic>> celebrations = whatsappProvider.getPreviousEvent().reversed.toList();
    return Container(
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       SizedBox(
          //         height: 30,
          //         child: OutlinedButton.icon(
          //           onPressed: () {
          //             WhatsappFunction.runEventCampaign(celebrations);
          //             print(celebrations.length);
          //           },
          //           icon: const Icon(FontAwesome.send, size: 13),
          //           label: Text(
          //             'Run Campaign',
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: DataTable2(
              columns: [
                DataColumn2(label: Text('Event date', style: style.textTheme.bodyLarge)),
                DataColumn2(label: Text('Customer Name', style: style.textTheme.bodyLarge)),
                DataColumn2(label: Text('Nickname', style: style.textTheme.bodyLarge)),
                DataColumn2(label: Text('Event', style: style.textTheme.bodyLarge)),
                const DataColumn2(label: Text('')),
              ],
              rows: List.generate(
                celebrations.length,
                (index) {
                  MEvent cele = celebrations[index]['e'];
                  MCustomer cust = celebrations[index]['c'];
                  String fdate = DateFormat.yMMMMd('en_US').format(cele.date!);
                  return DataRow.byIndex(
                    index: index,
                    cells: [
                      DataCell(Text(fdate)),
                      DataCell(Text(cust.name!)),
                      DataCell(Text(cust.nickname!)),
                      DataCell(Text(cele.name!)),
                      DataCell(
                        MyIconButton(
                          onPressed: () {
                            String message = '';
                            try {
                              if (cele.name == 'Birthday') {
                                message = 'Happy Birthday ${cust.nickname} 🎁🎉🎊\nMay god bless you with happy and healthy life.';
                              } else if (cele.name == 'Wedding') {
                                message = 'Happy Marriage anniversary ${cust.nickname} 🎉✨🎊';
                              }
                              WhatsappFunction().createMessage(number: cust.number.toString(), message: message);
                            } catch (e) {}
                          },
                          iconData: FontAwesome.send,
                          iconSize: 13,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
