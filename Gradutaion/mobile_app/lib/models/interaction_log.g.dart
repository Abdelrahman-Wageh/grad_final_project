// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InteractionLogAdapter extends TypeAdapter<InteractionLog> {
  @override
  final int typeId = 3;

  @override
  InteractionLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InteractionLog(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      gameState: fields[2] as String,
      gameContext: fields[3] as String,
      childQuery: fields[4] as String?,
      aiResponse: fields[5] as String?,
      success: fields[6] as bool,
      responseTime: fields[7] as Duration,
      metadata: (fields[8] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, InteractionLog obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.gameState)
      ..writeByte(3)
      ..write(obj.gameContext)
      ..writeByte(4)
      ..write(obj.childQuery)
      ..writeByte(5)
      ..write(obj.aiResponse)
      ..writeByte(6)
      ..write(obj.success)
      ..writeByte(7)
      ..write(obj.responseTime)
      ..writeByte(8)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InteractionLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
