// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_business.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MBusinessAdapter extends TypeAdapter<MBusiness> {
  @override
  final int typeId = 6;

  @override
  MBusiness read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MBusiness(
      todayincome: fields[0] as int?,
      todayExpenses: fields[1] as int?,
      daily: (fields[2] as List?)?.cast<MDataTableRow>(),
    )..date = fields[3] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, MBusiness obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.todayincome)
      ..writeByte(1)
      ..write(obj.todayExpenses)
      ..writeByte(2)
      ..write(obj.daily)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MBusinessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
