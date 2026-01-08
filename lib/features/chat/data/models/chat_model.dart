import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.name,
    required super.participantIds,
    required super.type,
    super.lastMessage,
    super.lastMessageAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'participantIds': participantIds,
      'type': type,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt,
    };
  }

  factory ChatModel.fromMap(String id, Map<String, dynamic> map) {
    return ChatModel(
      id: id,
      name: map['name'] as String,
      participantIds: List<String>.from(map['participantIds'] as List),
      type: map['type'] as String,
      lastMessage: map['lastMessage'] as String?,
      lastMessageAt: map['lastMessageAt'] != null
          ? (map['lastMessageAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'participantIds': participantIds,
    'type': type,
    'lastMessage': lastMessage,
    'lastMessageAt': lastMessageAt,
  };

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      name: json['name'] as String,
      participantIds: List<String>.from(json['participantIds'] as List),
      type: json['type'] as String,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageAt'],
    );
  }

  ChatModel copyWith({
    String? name,
    List<String>? participantIds,
    String? type,
    String? lastMessage,
    DateTime? lastMessageAt,
  }) {
    return ChatModel(
      id: id,
      name: name ?? this.name,
      participantIds: participantIds ?? this.participantIds,
      type: type ?? this.type,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}
