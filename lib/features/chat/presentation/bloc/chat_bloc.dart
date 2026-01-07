import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/features/chat/data/repositories/chat_repository.dart';
import 'package:flutter_chat_app/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:flutter_chat_app/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<GetChatsByUser>(_onGetChatsByUser);
  }

  Future<void> _onGetChatsByUser(
    GetChatsByUser event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    await emit.forEach<List<ChatEntity>>(
      chatRepository.getChatsByUser(
        event.userId,
      ), // Stream<List<MessageEntity>>
      onData: (chat) => ChatLoaded(chat),
      onError: (error, _) => ChatError(error.toString()),
    );
  }
}
