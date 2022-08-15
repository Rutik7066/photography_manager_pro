import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'm_bill.dart';
import 'm_event.dart';

part 'm_customer.g.dart';

@HiveType(typeId: 0)
class MCustomer extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? nickname; // For whatsapp function.
  @HiveField(2)
  String? number;
  @HiveField(3)
  String? address;
  @HiveField(4)
  List<MEvent>? events;
  @HiveField(5)
  List<MBill>? bills;
  @HiveField(6)
  int? totalRecoveryAmount;
  @HiveField(7)
  List<Map<String, dynamic>>?
      paymentHistory; //{	PaymentFor = bill/totalcredit,	Datetime,	Amount, Mode(note), }
  @HiveField(8)
  int? totalPendingWork;

  MCustomer({
    this.name,
    this.nickname,
    this.number,
    this.address,
    this.events,
    this.bills,
    this.totalRecoveryAmount,
    this.totalPendingWork,
    this.paymentHistory
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MCustomer &&
      other.name == name &&
      other.nickname == nickname &&
      other.number == number &&
      other.address == address &&
      listEquals(other.events, events) &&
      listEquals(other.bills, bills) &&
      other.totalRecoveryAmount == totalRecoveryAmount &&
      other.totalPendingWork == totalPendingWork;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      nickname.hashCode ^
      number.hashCode ^
      address.hashCode ^
      events.hashCode ^
      bills.hashCode ^
      totalRecoveryAmount.hashCode ^
      totalPendingWork.hashCode;
  }
}
