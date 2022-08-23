import 'dart:ffi';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/common_widgets/my_icon_button.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/whatsapp_services/whatsapp_function.dart';
import 'package:jk_photography_manager/whatsapp_services/whatsapp_provider.dart';
import 'package:provider/provider.dart';
import 'package:win32/win32.dart';

class RecoveryCampaign extends StatelessWidget {
  const RecoveryCampaign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    var whatsappProvider = Provider.of<WhatsappProvider>(context);
    List<MCustomer> list = whatsappProvider.getRecoveryList();
    return Container(
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       OutlinedButton.icon(
          //         onPressed: () {
          //           WhatsappFunction.runRecoveryCampaign(list);
          //         },
          //         icon: const Icon(FontAwesome.send, size: 13),
          //         label: Text(
          //           'Run Campaign',
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: DataTable2(
                columns: [
                  DataColumn2(label: Text('Index', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Customer', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Total unpaid', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Reciept', style: style.textTheme.bodyLarge)),
                ],
                rows: List.generate(list.length, (index) {
                  MCustomer c = list[index];
                  return DataRow.byIndex(index: index, cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(Text('${c.name}')),
                    DataCell(Text('${c.totalRecoveryAmount}')),
                    DataCell(
                      MyIconButton(
                        iconData: FontAwesome.send,
                        iconSize: 13,
                        onPressed: () async {
                          String message = 'Hi ${c.nickname}.\nWe are here to inform you that\nyour payment of \u20A8 ${c.totalRecoveryAmount} is still pending. Kindly pay as soon as possible.\nTo get more information about this kindly visit the studio.';
                          WhatsappFunction().createMessage(number: c.number.toString(), message: message);
                        },
                      ),
                    ),
                  ]);
                })),
          )
        ],
      ),
    );
  }
}
