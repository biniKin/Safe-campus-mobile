// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityModelHiveAdapter extends TypeAdapter<ActivityModelHive> {
  @override
  final int typeId = 1;

  @override
  ActivityModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityModelHive(
      id: fields[0] as String,
      time: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityModelHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
