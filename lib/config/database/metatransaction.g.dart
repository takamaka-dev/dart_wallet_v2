// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metatransaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MetatransactionAdapter extends TypeAdapter<Metatransaction> {
  @override
  final int typeId = 1;

  @override
  Metatransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Metatransaction(
      fields[0] as String,
      fields[1] as DateTime,
      fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Metatransaction obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.jsonHash)
      ..writeByte(1)
      ..write(obj.creationTimestamp)
      ..writeByte(2)
      ..write(obj.isSolved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetatransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
