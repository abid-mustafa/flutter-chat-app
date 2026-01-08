import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String name;
  final List<String> participantIds;
  final String type; // direct | group
  final String? lastMessage;
  final DateTime? lastMessageAt;

  const ChatEntity({
    required this.id,
    required this.name,
    required this.participantIds,
    required this.type,
    this.lastMessage,
    this.lastMessageAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    participantIds,
    type,
    lastMessage,
    lastMessageAt,
  ];
}
