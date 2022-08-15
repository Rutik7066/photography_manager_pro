import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:jk_photography_manager/model/daily/m_business.dart';
import 'package:jk_photography_manager/model/daily/m_datatable_row.dart';
import 'package:jk_photography_manager/repo/business_repo.dart';

class BusinessProvider extends ChangeNotifier {
  final _businessRepo = BusinessRepo();

  int todayExpense = 0;
  int todayIncome = 0;
  List<MDataTableRow> row = [];
  List<MBusiness> allday = [];

  init() {
    allday = _businessRepo.getAllBusinessDay();
    MBusiness? b = _businessRepo.getToday();
    if (b != null) {
      todayIncome = b.todayincome ?? 0;
      todayExpense = b.todayExpenses ?? 0;
      row = b.daily ?? [];
    }
  }

  Future export(String path)async {
    List<List<String>> data = [];
    var i = 0;
    _businessRepo.getAllBusinessDay().forEach((element) {
      
      for (var element in element.daily!) {
        i++;
        data.add([
          '$i',
          element.date.toString(),
          element.category.toString(),
          element.context.toString(),
          element.transaction.toString(),
          element.paymentmode.toString(),
        ]);
      }
    });
    List<List<String>> csvTable = [
      ['Index', 'Date', 'Category', 'Context', 'Transaction', 'PaymentMode'],
      ...data
    ];
    String csvData = const ListToCsvConverter().convert(csvTable);
    File file = File("${path}/photography.csv");
    await file.writeAsString(csvData);
  }

  void addRow({required String category, required dynamic type, required String typename, required String context, required int transaction, required String paymentmode}) {
    _businessRepo.addRow(paymentmode: paymentmode, type: type, typename: typename, context: context, transaction: transaction, category: category);
    MBusiness? today = _businessRepo.getToday();
    todayIncome = today != null ? today.todayincome! : 0;
    todayExpense = today != null ? today.todayExpenses! : 0;
    row = today != null ? today.daily! : [];
    print("Provider: $context");
    notifyListeners();
  }
}
