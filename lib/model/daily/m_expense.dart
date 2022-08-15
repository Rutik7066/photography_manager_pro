import 'package:hive/hive.dart';

part 'm_expense.g.dart';

@HiveType(typeId: 3)
class MExpenses extends HiveObject {
  @HiveField(0)
  String? category; // hardcoded String
  @HiveField(1)
  DateTime? date;
  @HiveField(2)
  int? amount;

  MExpenses({
    this.category,
    this.date,
    this.amount,
  });
}
