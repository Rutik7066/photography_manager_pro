// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MEventAdapter extends TypeAdapter<MEvent> {
  @override
  final int typeId = 2;

  @override
  MEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MEvent(
      name: fields[0] as String?,
      date: fields[1] as DateTime?,
      time: fields[2] as String?,
      description: fields[3] as String?,
      bill: fields[4] as MBill?,
      customername: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MEvent obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.bill)
      ..writeByte(5)
      ..write(obj.customername);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
