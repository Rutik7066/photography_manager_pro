import 'package:flutter/foundation.dart';
import 'package:jk_photography_manager/model/daily/m_expense.dart';
import 'package:jk_photography_manager/repo/finance_repo.dart';

class FinanceProvider extends ChangeNotifier {
  final _expRepo = FinanceRepo();

  List<String> allCategory = FinanceRepo().getAllcategory();
  List<MExpenses> allExpenses = FinanceRepo().getAllExpense();

  String? filterTagName;
  DateTime? filterDate;

  addCategory(String category) {
    _expRepo.addCategory(category);
    allCategory = _expRepo.getAllcategory();
    notifyListeners();
  }

  List<String> getCategoryByName(String p) {
    return _expRepo.getCategoryByName(p);
  }

  setExpensesByName(String p) {
    if (p != '') {
      allExpenses = _expRepo.getExpenseByCategory(p);
      notifyListeners();
    } else if (p == '') {
      allExpenses = _expRepo.getAllExpense();
      notifyListeners();
    }
  }

  filterExpensebydate(DateTime date) {
    allExpenses = _expRepo.getAllExpense().where((element) => element.date!.day == date.day).toList();
    notifyListeners();
  }

  filterExpnese() {
    if (filterTagName != null && filterDate == null) {
      setExpensesByName(filterTagName!);
    } else if (filterTagName == null && filterDate != null) {
      filterExpensebydate(filterDate!);
    } 
  }

  addExpense({required String cat, required int amt}) {
    _expRepo.addExpense(cat: cat, amt: amt);
    allExpenses = _expRepo.getAllExpense();
    notifyListeners();
  }
}
