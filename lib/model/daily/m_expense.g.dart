// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_expense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MExpensesAdapter extends TypeAdapter<MExpenses> {
  @override
  final int typeId = 3;

  @override
  MExpenses read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MExpenses(
      category: fields[0] as String?,
      date: fields[1] as DateTime?,
      amount: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MExpenses obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MExpensesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
