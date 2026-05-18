import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../data/models/child_profile.dart';
import '../models/spaced_repetition_card.dart';
import '../models/conversation_history.dart';
import '../models/message.dart';

/// Local storage service for offline-first data persistence
/// Handles CRUD operations for all Hive models
class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  final _uuid = const Uuid();

  // ============================================================================
  // CHILD PROFILE OPERATIONS
  // ============================================================================

  /// Get profiles box
  Box<ChildProfile> get _profilesBox => Hive.box<ChildProfile>('profiles');

  /// Save a child profile
  Future<void> saveProfile(ChildProfile profile) async {
    await _profilesBox.put(profile.id, profile);
  }

  /// Load a child profile by ID
  ChildProfile? loadProfile(String id) {
    return _profilesBox.get(id);
  }

  /// Get all child profiles
  List<ChildProfile> getAllProfiles() {
    return _profilesBox.values.toList();
  }

  /// Delete a child profile
  Future<void> deleteProfile(String id) async {
    await _profilesBox.delete(id);
  }

  /// Get current active profile (first profile or null)
  ChildProfile? getCurrentProfile() {
    final profiles = getAllProfiles();
    return profiles.isNotEmpty ? profiles.first : null;
  }

  /// Update profile's last played time and streak
  Future<void> updateProfileActivity(String profileId) async {
    final profile = loadProfile(profileId);
    if (profile != null) {
      profile.updateStreak();
      await profile.save();
    }
  }

  // ============================================================================
  // CONVERSATION HISTORY OPERATIONS
  // ============================================================================

  /// Get conversations box
  Box<ConversationHistory> get _conversationsBox => 
      Hive.box<ConversationHistory>('conversations');

  /// Get messages box
  Box<Message> get _messagesBox => Hive.box<Message>('messages');

  /// Create a new conversation
  Future<ConversationHistory> createConversation(String profileId) async {
    final conversation = ConversationHistory(
      id: _uuid.v4(),
      profileId: profileId,
    );
    
    await _conversationsBox.put(conversation.id, conversation);
    
    // Add reference to profile
    final profile = loadProfile(profileId);
    if (profile != null) {
      profile.addConversationHistory(conversation.id);
      await profile.save();
    }
    
    return conversation;
  }

  /// Get conversation by ID
  ConversationHistory? getConversation(String id) {
    return _conversationsBox.get(id);
  }

  /// Get all conversations for a profile
  List<ConversationHistory> getConversationsForProfile(String profileId) {
    return _conversationsBox.values
        .where((conv) => conv.profileId == profileId && !conv.isArchived)
        .toList()
      ..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
  }

  /// Get favorite conversations for a profile
  List<ConversationHistory> getFavoriteConversations(String profileId) {
    return _conversationsBox.values
        .where((conv) => conv.profileId == profileId && conv.isFavorite)
        .toList()
      ..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
  }

  /// Save a message to a conversation
  Future<Message> saveMessage({
    required String conversationId,
    required MessageRole role,
    required String content,
    String? audioPath,
    double? confidence,
    String? emotion,
    int? responseTimeMs,
  }) async {
    final message = Message(
      id: _uuid.v4(),
      role: role,
      content: content,
      audioPath: audioPath,
      confidence: confidence,
      emotion: emotion,
      responseTimeMs: responseTimeMs,
    );

    // Save message
    await _messagesBox.put(message.id, message);

    // Add message to conversation
    final conversation = getConversation(conversationId);
    if (conversation != null) {
      conversation.addMessage(message.id);
      
      // Auto-generate title from first user message
      if (conversation.title == null && role == MessageRole.user) {
        conversation.title = content.length > 30 
            ? '${content.substring(0, 30)}...' 
            : content;
      }
      
      await conversation.save();
    }

    return message;
  }

  /// Get message by ID
  Message? getMessage(String id) {
    return _messagesBox.get(id);
  }

  /// Get messages for a conversation with pagination
  List<Message> getConversationMessages(
    String conversationId, {
    int offset = 0,
    int limit = 20,
  }) {
    final conversation = getConversation(conversationId);
    if (conversation == null) return [];

    final messageIds = conversation.getMessages(offset: offset, limit: limit);
    return messageIds
        .map((id) => getMessage(id))
        .whereType<Message>()
        .toList();
  }

  /// Get recent messages for a conversation
  List<Message> getRecentMessages(String conversationId, {int count = 10}) {
    final conversation = getConversation(conversationId);
    if (conversation == null) return [];

    final messageIds = conversation.getRecentMessages(count: count);
    return messageIds
        .map((id) => getMessage(id))
        .whereType<Message>()
        .toList();
  }

  /// Delete a conversation and all its messages
  Future<void> deleteConversation(String conversationId) async {
    final conversation = getConversation(conversationId);
    if (conversation == null) return;

    // Delete all messages
    for (final messageId in conversation.messageIds) {
      await _messagesBox.delete(messageId);
    }

    // Delete conversation
    await _conversationsBox.delete(conversationId);

    // Remove reference from profile
    final profile = loadProfile(conversation.profileId);
    if (profile != null) {
      profile.conversationHistoryIds.remove(conversationId);
      await profile.save();
    }
  }

  // ============================================================================
  // SPACED REPETITION OPERATIONS
  // ============================================================================

  /// Get spaced repetition cards box
  Box<SpacedRepetitionCard> get _srCardsBox => 
      Hive.box<SpacedRepetitionCard>('sr_cards');

  /// Create a new spaced repetition card
  Future<SpacedRepetitionCard> createSpacedRepetitionCard({
    required String profileId,
    required String concept,
  }) async {
    final card = SpacedRepetitionCard(
      id: _uuid.v4(),
      profileId: profileId,
      concept: concept,
    );

    await _srCardsBox.put(card.id, card);

    // Add reference to profile
    final profile = loadProfile(profileId);
    if (profile != null) {
      profile.addSpacedRepetitionCard(card.id);
      await profile.save();
    }

    return card;
  }

  /// Get spaced repetition card by ID
  SpacedRepetitionCard? getSpacedRepetitionCard(String id) {
    return _srCardsBox.get(id);
  }

  /// Get all cards for a profile
  List<SpacedRepetitionCard> getCardsForProfile(String profileId) {
    return _srCardsBox.values
        .where((card) => card.profileId == profileId)
        .toList();
  }

  /// Get cards due for review
  List<SpacedRepetitionCard> getCardsForReview(String profileId) {
    return _srCardsBox.values
        .where((card) => card.profileId == profileId && card.isDue)
        .toList()
      ..sort((a, b) => a.nextReview.compareTo(b.nextReview));
  }

  /// Get card for a specific concept
  SpacedRepetitionCard? getCardForConcept(String profileId, String concept) {
    return _srCardsBox.values.firstWhere(
      (card) => card.profileId == profileId && card.concept == concept,
      orElse: () => SpacedRepetitionCard(
        id: '',
        profileId: '',
        concept: '',
      ),
    );
  }

  /// Update card with quality rating
  Future<void> updateCard(String cardId, int quality) async {
    final card = getSpacedRepetitionCard(cardId);
    if (card != null) {
      card.updateWithQuality(quality);
      // Card.save() is called inside updateWithQuality
    }
  }

  /// Get or create card for concept
  Future<SpacedRepetitionCard> getOrCreateCard({
    required String profileId,
    required String concept,
  }) async {
    final existingCard = getCardForConcept(profileId, concept);
    
    if (existingCard != null && existingCard.id.isNotEmpty) {
      return existingCard;
    }

    return await createSpacedRepetitionCard(
      profileId: profileId,
      concept: concept,
    );
  }

  /// Delete a spaced repetition card
  Future<void> deleteSpacedRepetitionCard(String cardId) async {
    final card = getSpacedRepetitionCard(cardId);
    if (card == null) return;

    await _srCardsBox.delete(cardId);

    // Remove reference from profile
    final profile = loadProfile(card.profileId);
    if (profile != null) {
      profile.spacedRepetitionCardIds.remove(cardId);
      await profile.save();
    }
  }

  // ============================================================================
  // STATISTICS & ANALYTICS
  // ============================================================================

  /// Get total messages sent by profile
  int getTotalMessagesForProfile(String profileId) {
    final conversations = getConversationsForProfile(profileId);
    return conversations.fold(0, (sum, conv) => sum + conv.messageCount);
  }

  /// Get total concepts learned (cards with success rate > 70%)
  int getConceptsMasteredCount(String profileId) {
    return _srCardsBox.values
        .where((card) => 
            card.profileId == profileId && 
            card.successRate >= 0.7 &&
            card.totalReviews >= 3)
        .length;
  }

  /// Get cards needing review count
  int getCardsNeedingReviewCount(String profileId) {
    return getCardsForReview(profileId).length;
  }

  /// Clear all data (for testing/reset)
  Future<void> clearAllData() async {
    await _profilesBox.clear();
    await _conversationsBox.clear();
    await _messagesBox.clear();
    await _srCardsBox.clear();
  }
}
