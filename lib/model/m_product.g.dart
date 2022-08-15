// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MProductAdapter extends TypeAdapter<MProduct> {
  @override
  final int typeId = 4;

  @override
  MProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MProduct(
      productname: fields[0] as String?,
      description: (fields[1] as List?)?.cast<String>(),
      price: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MProduct obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.productname)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
