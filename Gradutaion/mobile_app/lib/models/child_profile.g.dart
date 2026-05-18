// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildProfileAdapter extends TypeAdapter<ChildProfile> {
  @override
  final int typeId = 7;

  @override
  ChildProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChildProfile(
      name: fields[0] as String,
      age: fields[1] as int,
      level: fields[2] as String,
      assessment: fields[3] as String,
      masteredConcepts: (fields[4] as List?)?.cast<String>(),
      unlockedItems: (fields[5] as List?)?.cast<String>(),
      totalStars: fields[6] as int,
      createdAt: fields[7] as DateTime?,
      lastPlayedAt: fields[8] as DateTime?,
      conceptAttempts: (fields[9] as Map?)?.cast<String, int>(),
      recentSuccessRates: (fields[10] as List?)?.cast<double>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChildProfile obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.assessment)
      ..writeByte(4)
      ..write(obj.masteredConcepts)
      ..writeByte(5)
      ..write(obj.unlockedItems)
      ..writeByte(6)
      ..write(obj.totalStars)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastPlayedAt)
      ..writeByte(9)
      ..write(obj.conceptAttempts)
      ..writeByte(10)
      ..write(obj.recentSuccessRates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
