// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryAdapter extends TypeAdapter<Story> {
  @override
  final int typeId = 20;

  @override
  Story read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Story(
      id: fields[0] as String,
      titleAr: fields[1] as String,
      titleEn: fields[2] as String,
      theme: fields[3] as String,
      segments: (fields[4] as List).cast<StorySegment>(),
      difficulty: fields[5] as String,
      learningObjectives: (fields[6] as List).cast<String>(),
      thumbnailPath: fields[7] as String?,
      createdAt: fields[8] as DateTime?,
      isCompleted: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Story obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titleAr)
      ..writeByte(2)
      ..write(obj.titleEn)
      ..writeByte(3)
      ..write(obj.theme)
      ..writeByte(4)
      ..write(obj.segments)
      ..writeByte(5)
      ..write(obj.difficulty)
      ..writeByte(6)
      ..write(obj.learningObjectives)
      ..writeByte(7)
      ..write(obj.thumbnailPath)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StorySegmentAdapter extends TypeAdapter<StorySegment> {
  @override
  final int typeId = 21;

  @override
  StorySegment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StorySegment(
      textAr: fields[0] as String,
      textEn: fields[1] as String,
      imagePath: fields[2] as String?,
      choices: (fields[3] as List?)?.cast<StoryChoice>(),
      audioPath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StorySegment obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.textAr)
      ..writeByte(1)
      ..write(obj.textEn)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.choices)
      ..writeByte(4)
      ..write(obj.audioPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StorySegmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StoryChoiceAdapter extends TypeAdapter<StoryChoice> {
  @override
  final int typeId = 22;

  @override
  StoryChoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryChoice(
      textAr: fields[0] as String,
      textEn: fields[1] as String,
      nextSegmentIndex: fields[2] as int,
      consequence: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StoryChoice obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.textAr)
      ..writeByte(1)
      ..write(obj.textEn)
      ..writeByte(2)
      ..write(obj.nextSegmentIndex)
      ..writeByte(3)
      ..write(obj.consequence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryChoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
