// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'm_bill.dart';

part 'm_event.g.dart';

@HiveType(typeId: 2)
class MEvent extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  DateTime? date;
  @HiveField(2)
  String? time;
  @HiveField(3)
  String? description;
  @HiveField(4)
  MBill? bill;
  @HiveField(5)
  String? customername;

  MEvent({
    this.name,
    this.date,
this.time,
    this.description,
    this.bill,
    this.customername,
  });



  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MEvent &&
      other.name == name &&
      other.date == date &&
      other.time == time &&
      other.description == description &&
      other.bill == bill &&
      other.customername == customername;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      date.hashCode ^
      time.hashCode ^
      description.hashCode ^
      bill.hashCode ^
      customername.hashCode;
  }
}
