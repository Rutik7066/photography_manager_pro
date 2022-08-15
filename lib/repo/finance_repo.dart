import 'package:hive_flutter/hive_flutter.dart';
import 'package:jk_photography_manager/model/daily/m_expense.dart';
import 'package:jk_photography_manager/model/daily/m_finance.dart';

class FinanceRepo {
  final Box _exp = Hive.box('FinanceBox');

  MFinance fin = MFinance.fromMap(Hive.box('FinanceBox').toMap());

  List<String> getAllcategory() {
    return fin.category!;
  }

  List<String> getCategoryByName(String p) {
    return fin.category!.where((element) => element.toString().toLowerCase().startsWith(p.toLowerCase())).toList();
  }

  List<MExpenses> getAllExpense() {
    return fin.expenseList!;
  }

  List<MExpenses> getExpenseByCategory(String cat) {
    return fin.expenseList!.where((element) => element.category.toString().toLowerCase().startsWith(cat.toLowerCase())).cast<MExpenses>().toList();
  }

  addExpense({required String cat, required int amt}) {
    MExpenses ex = MExpenses(date: DateTime.now(), category: cat, amount: amt);
    fin.expenseList!.add(ex);
    _exp.put('expenseList', fin.expenseList!);
  }

  addCategory(String cat) {
    fin.category!.add(cat);
    _exp.put('category', fin.category!);
  }
}
