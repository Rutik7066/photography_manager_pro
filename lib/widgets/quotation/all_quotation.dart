import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:jk_photography_manager/common_widgets/widget_to_image/quotation_to_image.dart';
import 'package:jk_photography_manager/model/m_quotation.dart';
import 'package:jk_photography_manager/repo/quotation_repo.dart';

class AllQuotation extends StatefulWidget {
  const AllQuotation({Key? key}) : super(key: key);

  @override
  State<AllQuotation> createState() => _AllQuotationState();
}

class _AllQuotationState extends State<AllQuotation> {
  @override
  void initState() {
    print('Render');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<MQuotation> quotes = QuotationRepo().getAllQuotation();
    quotes.reversed.toList();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DataTable2(
          columns: const [
            DataColumn2(label: Text('Index')),
            DataColumn2(label: Text('Customer Name')),
            DataColumn2(label: Text('Customer Number')),
            DataColumn2(label: Text('Total')),
            DataColumn2(label: Text('Discount')),
            DataColumn2(label: Text('Final Total')),
          ],
          rows: List.generate(quotes.length, (index) {
            MQuotation quote = quotes[index];
            return DataRow2.byIndex(
                onDoubleTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return QuotationToImage(qou: quote);
                      });
                },
                index: index,
                cells: [
                  DataCell(Text(index.toString())),
                  DataCell(Text(quote.name)),
                  DataCell(Text(quote.number)),
                  DataCell(Text(quote.total.toString())),
                  DataCell(Text(quote.discount.toString())),
                  DataCell(Text(quote.finalTotal.toString())),
                ]);
          }),
        ),
      ),
    );
  }
}
