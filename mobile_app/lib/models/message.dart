import 'package:hive/hive.dart';

part 'message.g.dart';

/// Message role in conversation
@HiveType(typeId: 7)
enum MessageRole {
  @HiveField(0)
  user,

  @HiveField(1)
  assistant,

  @HiveField(2)
  system,
}

/// Individual message in a conversation
@HiveType(typeId: 8)
class Message extends HiveObject {
  /// Unique identifier
  @HiveField(0)
  String id;

  /// Message role (user, assistant, system)
  @HiveField(1)
  MessageRole role;

  /// Message content (text)
  @HiveField(2)
  String content;

  /// Timestamp when message was created
  @HiveField(3)
  DateTime timestamp;

  /// Audio file path (if voice message)
  @HiveField(4)
  String? audioPath;

  /// Transcription confidence (0.0 - 1.0)
  @HiveField(5)
  double? confidence;

  /// Detected emotion (happy, sad, excited, neutral)
  @HiveField(6)
  String? emotion;

  /// Response time in milliseconds
  @HiveField(7)
  int? responseTimeMs;

  Message({
    required this.id,
    required this.role,
    required this.content,
    DateTime? timestamp,
    this.audioPath,
    this.confidence,
    this.emotion,
    this.responseTimeMs,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Check if message is from user
  bool get isUser => role == MessageRole.user;

  /// Check if message is from assistant
  bool get isAssistant => role == MessageRole.assistant;

  /// Check if message is system message
  bool get isSystem => role == MessageRole.system;

  /// Get formatted timestamp
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  /// Create a copy with updated fields
  Message copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    String? audioPath,
    double? confidence,
    String? emotion,
    int? responseTimeMs,
  }) {
    return Message(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      audioPath: audioPath ?? this.audioPath,
      confidence: confidence ?? this.confidence,
      emotion: emotion ?? this.emotion,
      responseTimeMs: responseTimeMs ?? this.responseTimeMs,
    );
  }

  @override
  String toString() {
    return 'Message(role: $role, content: "${content.substring(0, content.length > 50 ? 50 : content.length)}...", '
           'time: $formattedTime)';
  }
}
