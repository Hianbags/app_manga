import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayMessage extends StatefulWidget {
  final String chatRoomId;
  final String currentUserId;

  const DisplayMessage({
    required this.chatRoomId,
    required this.currentUserId,
  });

  @override
  State<DisplayMessage> createState() => _DisplayMessageState();
}

class _DisplayMessageState extends State<DisplayMessage> {
  late final Stream<QuerySnapshot> _messagesStream;

  @override
  void initState() {
    super.initState();
    _messagesStream = FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messagesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Có lỗi xảy ra'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot doc = snapshot.data!.docs[index];
            Timestamp time = doc['time'];
            DateTime dateTime = time.toDate();
            bool isCurrentUser = doc['senderId'] == widget.currentUserId;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    doc['senderName'],  // Hiển thị tên người gửi cho tất cả tin nhắn
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 5.0,
                    color: isCurrentUser ? Colors.blue : Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Text(
                        doc['message'],
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  Text(
                    dateTime.toString(),
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
