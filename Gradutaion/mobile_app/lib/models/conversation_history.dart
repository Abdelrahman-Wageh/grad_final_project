import 'package:hive/hive.dart';
import 'message.dart';

part 'conversation_history.g.dart';

/// Conversation history for Friend Tab
/// Stores all messages between child and Smartino
@HiveType(typeId: 6)
class ConversationHistory extends HiveObject {
  /// Unique identifier
  @HiveField(0)
  String id;

  /// Profile ID this conversation belongs to
  @HiveField(1)
  String profileId;

  /// List of message IDs (references to Message objects)
  @HiveField(2)
  List<String> messageIds;

  /// Conversation title (auto-generated from first message)
  @HiveField(3)
  String? title;

  /// Timestamp when conversation started
  @HiveField(4)
  DateTime createdAt;

  /// Timestamp of last message
  @HiveField(5)
  DateTime lastMessageAt;

  /// Total number of messages
  @HiveField(6)
  int messageCount;

  /// Conversation tags (e.g., "colors", "numbers", "stories")
  @HiveField(7)
  List<String> tags;

  /// Is conversation archived
  @HiveField(8)
  bool isArchived;

  /// Child's favorite conversation
  @HiveField(9)
  bool isFavorite;

  ConversationHistory({
    required this.id,
    required this.profileId,
    List<String>? messageIds,
    this.title,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    this.messageCount = 0,
    List<String>? tags,
    this.isArchived = false,
    this.isFavorite = false,
  })  : messageIds = messageIds ?? [],
        createdAt = createdAt ?? DateTime.now(),
        lastMessageAt = lastMessageAt ?? DateTime.now(),
        tags = tags ?? [];

  /// Add a message to conversation
  void addMessage(String messageId) {
    messageIds.add(messageId);
    messageCount++;
    lastMessageAt = DateTime.now();
    save();
  }

  /// Get recent messages (last N)
  List<String> getRecentMessages({int count = 10}) {
    if (messageIds.length <= count) {
      return messageIds;
    }
    return messageIds.sublist(messageIds.length - count);
  }

  /// Get messages for pagination
  List<String> getMessages({int offset = 0, int limit = 20}) {
    if (offset >= messageIds.length) {
      return [];
    }

    final end = (offset + limit).clamp(0, messageIds.length);
    return messageIds.sublist(offset, end);
  }

  /// Add a tag to conversation
  void addTag(String tag) {
    if (!tags.contains(tag)) {
      tags.add(tag);
      save();
    }
  }

  /// Remove a tag from conversation
  void removeTag(String tag) {
    tags.remove(tag);
    save();
  }

  /// Toggle favorite status
  void toggleFavorite() {
    isFavorite = !isFavorite;
    save();
  }

  /// Archive conversation
  void archive() {
    isArchived = true;
    save();
  }

  /// Unarchive conversation
  void unarchive() {
    isArchived = false;
    save();
  }

  /// Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final conversationDate = DateTime(lastMessageAt.year, lastMessageAt.month, lastMessageAt.day);

    if (conversationDate == today) {
      return 'Today';
    } else if (conversationDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${lastMessageAt.day}/${lastMessageAt.month}/${lastMessageAt.year}';
    }
  }

  /// Create a copy with updated fields
  ConversationHistory copyWith({
    String? id,
    String? profileId,
    List<String>? messageIds,
    String? title,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    int? messageCount,
    List<String>? tags,
    bool? isArchived,
    bool? isFavorite,
  }) {
    return ConversationHistory(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      messageIds: messageIds ?? this.messageIds,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messageCount: messageCount ?? this.messageCount,
      tags: tags ?? this.tags,
      isArchived: isArchived ?? this.isArchived,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'ConversationHistory(id: $id, messages: $messageCount, '
           'lastMessage: $formattedDate, favorite: $isFavorite)';
  }
}
