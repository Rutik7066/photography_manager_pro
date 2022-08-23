import 'package:hive/hive.dart';

class MQuotation {
  String name;
  String number;
  List cart;
  int total;
  int discount;
  int finalTotal;

  MQuotation({
    required this.name,
    required this.number,
    required this.cart,
    required this.total,
    required this.discount,
    required this.finalTotal,
  });

  factory MQuotation.fromMap(map) {
    return MQuotation(
      cart: map['cart'] as List,
      discount: map['discount'] as int,
      finalTotal: map['finalTotal'] as int,
      name: map['name'] as String,
      number: map['number'] as String,
      total: map['total'] as int,
    );
  }
}
