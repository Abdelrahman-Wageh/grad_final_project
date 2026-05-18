// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildProfileAdapter extends TypeAdapter<ChildProfile> {
  @override
  final int typeId = 0;

  @override
  ChildProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChildProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      age: fields[2] as int,
      level: fields[3] as String,
      assessment: fields[4] as String,
      difficultyLevel: fields[5] as String,
      masteredConcepts: (fields[6] as List?)?.cast<String>(),
      conceptProgress: (fields[7] as Map?)?.cast<String, int>(),
      stars: fields[8] as int,
      unlockedItems: (fields[9] as List?)?.cast<String>(),
      currentChapter: fields[10] as String,
      currentStage: fields[11] as String,
      lastPlayed: fields[12] as DateTime?,
      totalPlayTimeMinutes: fields[13] as int,
      recentAttempts: (fields[14] as List?)?.cast<bool>(),
      wordsLearned: (fields[15] as Map?)?.cast<String, int>(),
      timePlayedPerDay: (fields[16] as Map?)?.cast<String, int>(),
      conversationHistoryIds: (fields[17] as List?)?.cast<String>(),
      spacedRepetitionCardIds: (fields[18] as List?)?.cast<String>(),
      unlockedTreasures: (fields[19] as List?)?.cast<String>(),
      currentStreak: fields[20] as int,
      longestStreak: fields[21] as int,
      lastSyncedAt: fields[22] as DateTime?,
      preferredLanguage: fields[23] as String,
      recentGameResults: (fields[24] as List?)?.cast<bool>(),
      needsSync: fields[25] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChildProfile obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.assessment)
      ..writeByte(5)
      ..write(obj.difficultyLevel)
      ..writeByte(6)
      ..write(obj.masteredConcepts)
      ..writeByte(7)
      ..write(obj.conceptProgress)
      ..writeByte(8)
      ..write(obj.stars)
      ..writeByte(9)
      ..write(obj.unlockedItems)
      ..writeByte(10)
      ..write(obj.currentChapter)
      ..writeByte(11)
      ..write(obj.currentStage)
      ..writeByte(12)
      ..write(obj.lastPlayed)
      ..writeByte(13)
      ..write(obj.totalPlayTimeMinutes)
      ..writeByte(14)
      ..write(obj.recentAttempts)
      ..writeByte(15)
      ..write(obj.wordsLearned)
      ..writeByte(16)
      ..write(obj.timePlayedPerDay)
      ..writeByte(17)
      ..write(obj.conversationHistoryIds)
      ..writeByte(18)
      ..write(obj.spacedRepetitionCardIds)
      ..writeByte(19)
      ..write(obj.unlockedTreasures)
      ..writeByte(20)
      ..write(obj.currentStreak)
      ..writeByte(21)
      ..write(obj.longestStreak)
      ..writeByte(22)
      ..write(obj.lastSyncedAt)
      ..writeByte(23)
      ..write(obj.preferredLanguage)
      ..writeByte(24)
      ..write(obj.recentGameResults)
      ..writeByte(25)
      ..write(obj.needsSync);
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
