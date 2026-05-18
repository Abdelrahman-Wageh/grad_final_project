// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DevSettingsAdapter extends TypeAdapter<DevSettings> {
  @override
  final int typeId = 11;

  @override
  DevSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DevSettings(
      aiMode: fields[0] as AIMode,
      whisperPath: fields[1] as String,
      qwenPath: fields[2] as String,
      ttsPath: fields[3] as String,
      enableDebugLogs: fields[4] as bool,
      showPerformanceOverlay: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DevSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.aiMode)
      ..writeByte(1)
      ..write(obj.whisperPath)
      ..writeByte(2)
      ..write(obj.qwenPath)
      ..writeByte(3)
      ..write(obj.ttsPath)
      ..writeByte(4)
      ..write(obj.enableDebugLogs)
      ..writeByte(5)
      ..write(obj.showPerformanceOverlay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DevSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
