import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class GetChatsByUser extends ChatEvent {
  final String userId;

  const GetChatsByUser(this.userId);

  @override
  List<Object> get props => [userId];
}
