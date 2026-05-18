import 'package:hive/hive.dart';
import 'dev_settings.dart';

/// Hive TypeAdapter for AIMode enum
class AIModeAdapter extends TypeAdapter<AIMode> {
  @override
  final int typeId = 9; // Unique type ID for AIMode

  @override
  AIMode read(BinaryReader reader) {
    final index = reader.readByte();
    return AIMode.values[index];
  }

  @override
  void write(BinaryWriter writer, AIMode obj) {
    writer.writeByte(obj.index);
  }
}
