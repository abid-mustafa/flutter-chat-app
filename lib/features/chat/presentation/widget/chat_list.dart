import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter_chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:flutter_chat_app/features/chat/presentation/bloc/chat_state.dart';
import 'package:flutter_chat_app/util/format_dart.dart';

class ChatListPage extends StatefulWidget {
  final String userId;
  const ChatListPage({super.key, required this.userId});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetChatsByUser(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.cyan,
                      strokeWidth: 3,
                    ),
                  );
                }

                if (state is ChatLoaded) {
                  return ListView.separated(
                    itemCount: state.chats.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final chat = state.chats[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        title: Text(
                          chat.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: chat.lastMessage != null
                            ? Text(
                                chat.lastMessage!,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        trailing: chat.lastMessageAt != null
                            ? Text(
                                formatDate(chat.lastMessageAt!),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              )
                            : null,
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    },
                  );
                }

                if (state is ChatError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return const Center(child: Text('No chats'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
