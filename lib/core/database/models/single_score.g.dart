// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SingleScoreAdapter extends TypeAdapter<SingleScore> {
  @override
  final int typeId = 2;

  @override
  SingleScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SingleScore(
      mode: fields[0] as String,
      attempts: fields[1] as int,
      date: fields[2] as DateTime,
      category: fields[3] as String,
      level: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SingleScore obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.mode)
      ..writeByte(1)
      ..write(obj.attempts)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.level);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SingleScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
