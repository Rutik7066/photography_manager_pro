// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_bill.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MBillAdapter extends TypeAdapter<MBill> {
  @override
  final int typeId = 1;

  @override
  MBill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MBill(
      customername: fields[12] as String?,
      billindex: fields[11] as int?,
      created: fields[10] as DateTime?,
      type: fields[0] as String?,
      description: fields[1] as String?,
      total: fields[3] as int?,
      discount: fields[4] as int?,
      finalTotal: fields[5] as int?,
      paymentOrAdvance: fields[6] as int?,
      unPaid: fields[7] as int?,
      paymentHistoryOfBill: (fields[8] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      cart: (fields[2] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      status: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MBill obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.cart)
      ..writeByte(3)
      ..write(obj.total)
      ..writeByte(4)
      ..write(obj.discount)
      ..writeByte(5)
      ..write(obj.finalTotal)
      ..writeByte(6)
      ..write(obj.paymentOrAdvance)
      ..writeByte(7)
      ..write(obj.unPaid)
      ..writeByte(8)
      ..write(obj.paymentHistoryOfBill)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.created)
      ..writeByte(11)
      ..write(obj.billindex)
      ..writeByte(12)
      ..write(obj.customername);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MBillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
