import 'package:hive_flutter/hive_flutter.dart';
import 'package:jk_photography_manager/model/daily/m_business.dart';
import 'package:jk_photography_manager/model/daily/m_datatable_row.dart';

class BusinessRepo {
  final Box<MBusiness> _businessBox = Hive.box<MBusiness>('BusinessBox');

  List<MBusiness> getAllBusinessDay() {
    return _businessBox.values.cast<MBusiness>().toList();
  }

  List<MBusiness> getBusinessByDate(DateTime date) {
    return _businessBox.values.where((element) => element.date == date).cast<MBusiness>().toList();
  }

  MBusiness? getToday() {
    String key = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString();
    return _businessBox.get(key);
  }

  void addRow({required String paymentmode, required String category, required dynamic type, required String typename, required String context, required int transaction}) {
    String key = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString();
    MBusiness? day = _businessBox.get(key);
    MDataTableRow row = MDataTableRow(
      paymentmode: paymentmode,
      category: category,
      date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      type: type,
      typename: typename,
      context: context,
      transaction: transaction,
    );
    if (day != null) {
      day.daily!.add(row);
      if (row.category == 'Income') {
        day.todayincome = day.todayincome! + row.transaction!;
      } else if (row.category == 'Expense') {
        day.todayExpenses = day.todayExpenses! + row.transaction!;
      }
      day.save();
    } else if (day == null) {
      MBusiness newDay = MBusiness(todayincome: 0, todayExpenses: 0, daily: [row]);
      if (row.category == 'Income') {
        newDay.todayincome = newDay.todayincome! + row.transaction!;
      } else if (row.category == 'Expense') {
        newDay.todayExpenses = newDay.todayExpenses! + row.transaction!;
      }
    print("Repo: $context");

      _businessBox.put(key, newDay);
    }
    // for (var element in _businessBox.values) {
    //   print(element.todayincome);
    //   print(element.todayExpenses);
    //   print(element.daily!.length);
    // }
  }

  void deleteRow() {}
}
