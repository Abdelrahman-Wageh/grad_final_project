// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversationHistoryAdapter extends TypeAdapter<ConversationHistory> {
  @override
  final int typeId = 6;

  @override
  ConversationHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversationHistory(
      id: fields[0] as String,
      profileId: fields[1] as String,
      messageIds: (fields[2] as List?)?.cast<String>(),
      title: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
      lastMessageAt: fields[5] as DateTime?,
      messageCount: fields[6] as int,
      tags: (fields[7] as List?)?.cast<String>(),
      isArchived: fields[8] as bool,
      isFavorite: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ConversationHistory obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.profileId)
      ..writeByte(2)
      ..write(obj.messageIds)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastMessageAt)
      ..writeByte(6)
      ..write(obj.messageCount)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.isArchived)
      ..writeByte(9)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
