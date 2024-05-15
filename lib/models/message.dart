// ignore_for_file: non_constant_identifier_names, avoid_print

// Class to store messages
class Message {
  final String message;
  final int sender_id;
  final String sender_name;
  final String room_id;
  final DateTime timestamp;

  Message(
      {required this.message,
      required this.sender_id,
      required this.sender_name,
      required this.room_id,
      required this.timestamp});

  // Convert a Message into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'message': message,
      'sender_id': sender_id,
      'sender_name': sender_name,
      'room_id': room_id,
      'timestamp': timestamp,
    };
  }

  factory Message.fromJson(Map<String, dynamic> msg) {
    print('msg = $msg');
    return Message(
      message:
          msg['message'] ?? '', // Provide a default value if 'message' is null
      sender_id: msg['sender_id'] ??
          0, // Provide a default value if 'sender_id' is null
      sender_name: msg['sender_name'] ??
          '', // Provide a default value if 'sender_name' is null
      room_id:
          msg['room_id'] ?? '', // Provide a default value if 'room_id' is null
      timestamp: msg['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(msg['timestamp'])
          : DateTime.now(), // Convert to DateTime if 'timestamp' is not null
    );
  }

  // Implement toString to make it easier to see information about
  // each user when using the print statement.
  @override
  String toString() {
    return 'Message{sender_id: $sender_id, sender_name: $sender_name, message: $message }';
  }
}
