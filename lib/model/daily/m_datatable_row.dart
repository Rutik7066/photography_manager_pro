// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'm_datatable_row.g.dart';

@HiveType(typeId: 5)
class MDataTableRow extends HiveObject {
  @HiveField(0)
  String? category; // Income || Expense.
  @HiveField(1)
  dynamic type; // for pass the data: expense, bill
  @HiveField(2)
  String? typename; // for name flag or text
  @HiveField(3)
  String? context; // Income: Name || Expense: category.
  @HiveField(4)
  int? transaction; // Income: Payment || Expense: Payment


  @HiveField(5)
  DateTime? date;
    @HiveField(6)
  String? paymentmode;
  MDataTableRow({
    required this.category,
    required this.type,
    required this.typename,
    required this.context,
    required this.transaction,
    required this.paymentmode,
    required this.date,
  });
}
