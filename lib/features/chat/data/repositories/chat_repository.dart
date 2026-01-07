import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/features/chat/data/models/chat_model.dart';
import 'package:flutter_chat_app/features/chat/domain/entities/chat_entity.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Query _getChatsCollection(String userId) {
    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true);
  }

  // @override
  // Future<void> sendMessage(String groupId, MessageEntity message) async {
  //   final messageModel = MessageModel(
  //     id: message.id,
  //     text: message.text,
  //     senderId: message.senderId,
  //     senderName: message.senderName,
  //     timestamp: message.timestamp,
  //     readBy: message.readBy,
  //   );

  //   await _getMessagesCollection(groupId)
  //       .doc(message.id)
  //       .set(messageModel.toMap());
  // }

  Stream<List<ChatEntity>> getChatsByUser(String userId) {
    return _getChatsCollection(userId).snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                ChatModel.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
