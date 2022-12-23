import 'package:hive/hive.dart';

part 'm_bill.g.dart';

@HiveType(typeId: 1)
class MBill extends HiveObject {
  @HiveField(0)
  String? type; // regular or event
  @HiveField(1)
  String? description; // optional
  @HiveField(2)
  List<Map<String, dynamic>>? cart; // list of Map = {name,qty, peritemPrice, total price of product}
  @HiveField(3)
  int? total; // total exclusive discount
  @HiveField(4)
  int? discount;
  @HiveField(5)
  int? finalTotal; // total - discount;
  @HiveField(6)
  int? paymentOrAdvance; // payment while making bill or advance;
  @HiveField(7)
  int? unPaid; // final - payment
  @HiveField(8)
  List<Map<String, dynamic>>? paymentHistoryOfBill; // list of map = {date,amount,mode(note)}
  @HiveField(9)
  int? status; // 0 = Pending, 1 = Completed, 2 = Delivered.
  @HiveField(10)
  DateTime? created;
  @HiveField(11)
  int? billindex;
  @HiveField(12)
  String? customername;

  MBill({
    this.customername,
    this.billindex,
    this.created,
    this.type,
    this.description,
    this.total,
    this.discount,
    this.finalTotal,
    this.paymentOrAdvance,
    this.unPaid,
    this.paymentHistoryOfBill,
    this.cart,
    this.status,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MBill && other.type == type && other.description == description && other.total == total && other.discount == discount && other.finalTotal == finalTotal && other.paymentOrAdvance == paymentOrAdvance && other.unPaid == unPaid && other.status == status && other.created == created;
  }

  @override
  int get hashCode {
    return type.hashCode ^ description.hashCode ^ total.hashCode ^ discount.hashCode ^ finalTotal.hashCode ^ paymentOrAdvance.hashCode ^ unPaid.hashCode ^ status.hashCode ^ created.hashCode;
  }
}
