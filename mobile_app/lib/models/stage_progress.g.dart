// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StageProgressAdapter extends TypeAdapter<StageProgress> {
  @override
  final int typeId = 10;

  @override
  StageProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StageProgress(
      stageId: fields[0] as String,
      stars: fields[1] as int,
      bestStars: fields[2] as int,
      isCompleted: fields[3] as bool,
      attempts: fields[4] as int,
      lastPlayedAt: fields[5] as DateTime,
      correctAnswers: fields[6] as int,
      totalQuestions: fields[7] as int,
      bestTime: fields[8] as Duration?,
    );
  }

  @override
  void write(BinaryWriter writer, StageProgress obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.stageId)
      ..writeByte(1)
      ..write(obj.stars)
      ..writeByte(2)
      ..write(obj.bestStars)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.attempts)
      ..writeByte(5)
      ..write(obj.lastPlayedAt)
      ..writeByte(6)
      ..write(obj.correctAnswers)
      ..writeByte(7)
      ..write(obj.totalQuestions)
      ..writeByte(8)
      ..write(obj.bestTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StageProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
