// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:hive/hive.dart';

class MUser {
  String userName;
  String userNumber;
  String userBussinessName;
  String userBussinessAddress;
  Uint8List? logo ;
  DateTime endDate;

  MUser({
    required this.userName,
    required this.userNumber,
    required this.userBussinessName,
    required this.userBussinessAddress,
    required this.logo,
    required this.endDate,
  });

  MUser copyWith({
    String? userName,
    String? userNumber,
    String? userBussinessName,
    String? userBussinessAddress,
    Uint8List? logo,
    DateTime? endDate,
  }) {
    return MUser(
      userName: userName ?? this.userName,
      userNumber: userNumber ?? this.userNumber,
      userBussinessName: userBussinessName ?? this.userBussinessName,
      userBussinessAddress: userBussinessAddress ?? this.userBussinessAddress,
      logo: logo ?? this.logo,
      endDate: endDate ?? this.endDate,
    );
  }

 

  @override
  String toString() {
    return 'MUser(userName: $userName, userNumber: $userNumber, userBussinessName: $userBussinessName, userBussinessAddress: $userBussinessAddress, logo: $logo, endDate: $endDate)';
  }

  @override
  bool operator ==(covariant MUser other) {
    if (identical(this, other)) return true;

    return other.userName == userName &&
        other.userNumber == userNumber &&
        other.userBussinessName == userBussinessName &&
        other.userBussinessAddress == userBussinessAddress &&
        other.logo == logo &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return userName.hashCode ^ userNumber.hashCode ^ userBussinessName.hashCode ^ userBussinessAddress.hashCode ^ logo.hashCode ^ endDate.hashCode;
  }

  factory MUser.fromBox(Box map) {
    return MUser(
      userName: map.get('userName') as String,
      userNumber: map.get('userNumber') as String,
      userBussinessName: map.get('userBussinessName') as String,
      userBussinessAddress: map.get('userBussinessAddress') as String,
      logo:   map.get('logo') as Uint8List?,
      endDate: map.get('endDate') as DateTime,
    );
  }

}
