import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:jk_photography_manager/model/daily/m_business.dart';
import 'package:jk_photography_manager/provider/business_provider.dart';
import 'package:jk_photography_manager/widgets/studio/widget/alert_today.dart';
import 'package:provider/provider.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    var today = Provider.of<BusinessProvider>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton.icon(
                onPressed: () async {
                  var path = await FilePicker.platform.getDirectoryPath();
                  if (path != null) {
                    today.export(path).then(
                          (value) => showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(content: Text('Export Succefull !')),
                          ),
                        );
                  }
                },
                icon: const Icon(MaterialCommunityIcons.export_variant, size: 20),
                label: const Text('Export CSV')),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable2(
                columns: [
                  DataColumn2(label: Text('Index', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Date', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Income', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Expense', style: style.textTheme.bodyLarge)),
                ],
                rows: List.generate(
                  today.allday.length,
                  (index) {
                    MBusiness aday = today.allday.reversed.toList()[index];
                    String fdate = DateFormat.yMMMMd('en_US').format(aday.date!);
                    return DataRow2.byIndex(
                        color: MaterialStateProperty.all(style.canvasColor),
                        index: index,
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(fdate, style: style.textTheme.bodyMedium)),
                          DataCell(Text('${aday.todayincome}', style: style.textTheme.bodyMedium)),
                          DataCell(Text('${aday.todayExpenses}', style: style.textTheme.bodyMedium)),
                        ],
                        onDoubleTap: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertToday(aday: aday);
                              });
                        });
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
