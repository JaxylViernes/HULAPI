// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveAccount.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveAccountAdapter extends TypeAdapter<HiveAccount> {
  @override
  final int typeId = 0;

  @override
  HiveAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAccount(
      name: fields[0] as String,
      avatar: fields[1] as String,
      score: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveAccount obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.avatar)
      ..writeByte(2)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
