// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_customer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MCustomerAdapter extends TypeAdapter<MCustomer> {
  @override
  final int typeId = 0;

  @override
  MCustomer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MCustomer(
      name: fields[0] as String?,
      nickname: fields[1] as String?,
      number: fields[2] as String?,
      address: fields[3] as String?,
      events: (fields[4] as List?)?.cast<MEvent>(),
      bills: (fields[5] as List?)?.cast<MBill>(),
      totalRecoveryAmount: fields[6] as int?,
      totalPendingWork: fields[8] as int?,
      paymentHistory: (fields[7] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, MCustomer obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.nickname)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.events)
      ..writeByte(5)
      ..write(obj.bills)
      ..writeByte(6)
      ..write(obj.totalRecoveryAmount)
      ..writeByte(7)
      ..write(obj.paymentHistory)
      ..writeByte(8)
      ..write(obj.totalPendingWork);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MCustomerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
