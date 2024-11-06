import 'package:appmanga/Chat/page/message_page.dart';
import 'package:appmanga/Chat/roomchat/model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class ChatPage extends StatefulWidget {
  final String currentUserId;
  final RoomChat roomChat;

  const ChatPage({
    required this.currentUserId,
    required this.roomChat,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomChat.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: DisplayMessage(
              chatRoomId: widget.roomChat.id.toString(),
              currentUserId: widget.currentUserId,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _firestore
                          .collection('chat_rooms')
                          .doc(widget.roomChat.id.toString())
                          .collection('messages')
                          .doc()
                          .set({
                        'message': _messageController.text,
                        'time': Timestamp.now(),
                        'senderId': widget.currentUserId,
                        'senderName': widget.currentUserId,
                      }).then((value) {
                        _messageController.clear();
                      }).catchError((error) {
                        print('Gửi tin nhắn thất bại: $error');
                      });
                    }
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
