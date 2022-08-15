// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_datatable_row.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MDataTableRowAdapter extends TypeAdapter<MDataTableRow> {
  @override
  final int typeId = 5;

  @override
  MDataTableRow read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MDataTableRow(
      category: fields[0] as String?,
      type: fields[1] as dynamic,
      typename: fields[2] as String?,
      context: fields[3] as String?,
      transaction: fields[4] as int?,
      paymentmode: fields[6] as String?,
      date: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MDataTableRow obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.typename)
      ..writeByte(3)
      ..write(obj.context)
      ..writeByte(4)
      ..write(obj.transaction)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.paymentmode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MDataTableRowAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
