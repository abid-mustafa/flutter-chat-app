// ignore_for_file: library_prefixes, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chat_app/database_functions.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/providers/chat.dart';
import 'package:chat_app/screens/user_select.dart';

class ChatPage extends StatefulWidget {
  // variables to store message data
  final String username;
  final int userid;
  final String othername;
  final int otherid;
  final String roomid;

  const ChatPage({
    Key? key,
    required this.username,
    required this.userid,
    required this.othername,
    required this.otherid,
    required this.roomid,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Creating a socketIO socket
  late IO.Socket _socket;
  // List to store messages
  late Future<List<Message>> _chatFuture;
  final TextEditingController _messageInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetching chat history
    _chatFuture = getChat(widget.roomid);
    // Initializing the socket connection
    _initSocket();
  }

  @override
  void dispose() {
    // Dispose of resources
    _messageInputController.dispose();
    _socket.dispose();
    super.dispose();
  }

  void _initSocket() {
    // Creating a socket connection
    _socket = IO.io(
      'http://192.168.100.195:3000',
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );
    // Establishing connection
    _socket.connect();
    // Event listeners
    _socket.onConnect((_) => print('Connection established'));
    _socket.onConnectError((data) {
      print('Connection error: $data');
      // Showing connection error dialog
      _showConnectionErrorDialog();
      // Disconnecting socket
      _socket.disconnect();
    });
    _socket.onDisconnect((_) => print('Socket.IO server disconnected'));
    // Joining chat room
    _socket.emit('joinRoom', widget.roomid);
    // Listening for incoming messages
    _socket.on('message', _handleMessage);
  }

  void _handleMessage(data) {
    // Handling incoming messages
    final message = Message.fromJson(data);
    Provider.of<ChatProvider>(context, listen: false).addNewMessage(message);
  }

  void _sendMessage() {
    // Sending message to server
    final messageText = _messageInputController.text.trim();
    if (messageText.isEmpty) return;

    _socket.emit('message', {
      'message': messageText,
      'sender_name': widget.username,
      'sender_id': widget.userid,
      'room_id': widget.roomid,
    });

    // Adding message to local storage
    addMessage(widget.userid, widget.username, messageText, widget.roomid);
    // Clearing message input
    _messageInputController.clear();
  }

  void _showConnectionErrorDialog() {
    // Showing connection error dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Connection Error'),
        content: const Text(
          'Unable to connect to the server. Please try again later.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Dismissing dialog and navigating to user select page
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => UserSelect(
                    username: widget.username,
                    userid: widget.userid,
                  ),
                ),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Message message, bool isOwnMessage) {
    // Building message item widget
    return Wrap(
      alignment: isOwnMessage ? WrapAlignment.end : WrapAlignment.start,
      children: [
        Card(
          color:
              isOwnMessage ? Theme.of(context).primaryColorLight : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isOwnMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(message.message),
                Text(
                  DateFormat('hh:mm a').format(message.timestamp),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.othername),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: _chatFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Displaying loading indicator while fetching chat history
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // Displaying error message if chat history retrieval fails
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final databaseMessages = snapshot.data ?? [];
                  final realTimeMessages =
                      Provider.of<ChatProvider>(context).messages;
                  final allMessages = [
                    ...databaseMessages,
                    ...realTimeMessages
                  ];

                  // Displaying messages
                  return ListView.builder(
                    itemCount: allMessages.length,
                    itemBuilder: (context, index) {
                      final message = allMessages[index];
                      final isOwnMessage = message.sender_id == widget.userid;
                      return _buildMessageItem(message, isOwnMessage);
                    },
                  );
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageInputController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: _messageInputController.text.trim().isEmpty
                        ? null
                        : _sendMessage,
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
