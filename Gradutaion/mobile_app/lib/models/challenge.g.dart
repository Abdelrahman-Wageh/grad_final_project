// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChallengeAdapter extends TypeAdapter<Challenge> {
  @override
  final int typeId = 6;

  @override
  Challenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Challenge(
      type: fields[0] as ChallengeType,
      prompt: fields[1] as String,
      expectedAnswer: fields[2] as String,
      alternativeAnswers: (fields[3] as List).cast<String>(),
      difficulty: fields[4] as DifficultyLevel,
      data: (fields[5] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Challenge obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.prompt)
      ..writeByte(2)
      ..write(obj.expectedAnswer)
      ..writeByte(3)
      ..write(obj.alternativeAnswers)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeTypeAdapter extends TypeAdapter<ChallengeType> {
  @override
  final int typeId = 4;

  @override
  ChallengeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChallengeType.vocabulary;
      case 1:
        return ChallengeType.sentence;
      case 2:
        return ChallengeType.counting;
      case 3:
        return ChallengeType.colorRecognition;
      case 4:
        return ChallengeType.shapeRecognition;
      case 5:
        return ChallengeType.animalSound;
      case 6:
        return ChallengeType.drawing;
      case 7:
        return ChallengeType.memory;
      case 8:
        return ChallengeType.cumulative;
      default:
        return ChallengeType.vocabulary;
    }
  }

  @override
  void write(BinaryWriter writer, ChallengeType obj) {
    switch (obj) {
      case ChallengeType.vocabulary:
        writer.writeByte(0);
        break;
      case ChallengeType.sentence:
        writer.writeByte(1);
        break;
      case ChallengeType.counting:
        writer.writeByte(2);
        break;
      case ChallengeType.colorRecognition:
        writer.writeByte(3);
        break;
      case ChallengeType.shapeRecognition:
        writer.writeByte(4);
        break;
      case ChallengeType.animalSound:
        writer.writeByte(5);
        break;
      case ChallengeType.drawing:
        writer.writeByte(6);
        break;
      case ChallengeType.memory:
        writer.writeByte(7);
        break;
      case ChallengeType.cumulative:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DifficultyLevelAdapter extends TypeAdapter<DifficultyLevel> {
  @override
  final int typeId = 5;

  @override
  DifficultyLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DifficultyLevel.easy;
      case 1:
        return DifficultyLevel.medium;
      case 2:
        return DifficultyLevel.hard;
      default:
        return DifficultyLevel.easy;
    }
  }

  @override
  void write(BinaryWriter writer, DifficultyLevel obj) {
    switch (obj) {
      case DifficultyLevel.easy:
        writer.writeByte(0);
        break;
      case DifficultyLevel.medium:
        writer.writeByte(1);
        break;
      case DifficultyLevel.hard:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
