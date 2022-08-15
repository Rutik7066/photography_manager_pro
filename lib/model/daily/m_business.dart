import 'package:hive/hive.dart';

import 'package:jk_photography_manager/model/daily/m_datatable_row.dart';

part 'm_business.g.dart';

@HiveType(typeId: 6)
class MBusiness  extends HiveObject{
  @HiveField(0)
  int? todayincome;
  @HiveField(1)
  int? todayExpenses;
  @HiveField(2)
  List<MDataTableRow>? daily;
  @HiveField(3)
  DateTime? date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  MBusiness({
    required this.todayincome,
    required this.todayExpenses,
    required this.daily,
  });
}
