import 'package:hive/hive.dart';

part 'interaction_log.g.dart';

@HiveType(typeId: 3)
class InteractionLog {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime timestamp;
  
  @HiveField(2)
  final String gameState;
  
  @HiveField(3)
  final String gameContext;
  
  @HiveField(4)
  final String? childQuery;
  
  @HiveField(5)
  final String? aiResponse;
  
  @HiveField(6)
  final bool success;
  
  @HiveField(7)
  final Duration responseTime;
  
  @HiveField(8)
  final Map<String, dynamic> metadata;

  InteractionLog({
    required this.id,
    required this.timestamp,
    required this.gameState,
    required this.gameContext,
    this.childQuery,
    this.aiResponse,
    required this.success,
    required this.responseTime,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'gameState': gameState,
      'gameContext': gameContext,
      'childQuery': childQuery,
      'aiResponse': aiResponse,
      'success': success,
      'responseTime': responseTime.inMilliseconds,
      'metadata': metadata,
    };
  }

  factory InteractionLog.fromJson(Map<String, dynamic> json) {
    return InteractionLog(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      gameState: json['gameState'],
      gameContext: json['gameContext'],
      childQuery: json['childQuery'],
      aiResponse: json['aiResponse'],
      success: json['success'],
      responseTime: Duration(milliseconds: json['responseTime']),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}
