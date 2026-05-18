// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaced_repetition_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpacedRepetitionCardAdapter extends TypeAdapter<SpacedRepetitionCard> {
  @override
  final int typeId = 5;

  @override
  SpacedRepetitionCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpacedRepetitionCard(
      id: fields[0] as String,
      profileId: fields[1] as String,
      concept: fields[2] as String,
      repetitions: fields[3] as int,
      interval: fields[4] as int,
      easeFactor: fields[5] as double,
      nextReview: fields[6] as DateTime?,
      lastReview: fields[7] as DateTime?,
      lastQuality: fields[8] as int?,
      totalReviews: fields[9] as int,
      correctCount: fields[10] as int,
      createdAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SpacedRepetitionCard obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.profileId)
      ..writeByte(2)
      ..write(obj.concept)
      ..writeByte(3)
      ..write(obj.repetitions)
      ..writeByte(4)
      ..write(obj.interval)
      ..writeByte(5)
      ..write(obj.easeFactor)
      ..writeByte(6)
      ..write(obj.nextReview)
      ..writeByte(7)
      ..write(obj.lastReview)
      ..writeByte(8)
      ..write(obj.lastQuality)
      ..writeByte(9)
      ..write(obj.totalReviews)
      ..writeByte(10)
      ..write(obj.correctCount)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpacedRepetitionCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
