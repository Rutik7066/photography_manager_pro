// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:jk_photography_manager/model/daily/m_expense.dart';

class MFinance {
  List<String>? category = [];

  List<MExpenses>? expenseList = [];
  MFinance({
    this.category,
    this.expenseList,
  });

  factory MFinance.fromMap(Map<dynamic, dynamic> map) {
    List<String> catList =  map[ 'category'] ?? [];
    List<dynamic> explist = map['expenseList']?? [];
    return MFinance(
      category: catList.cast(),
      expenseList: explist.cast<MExpenses>(),
    );
  }
}
