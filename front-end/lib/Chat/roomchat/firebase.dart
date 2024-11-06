import 'package:cloud_firestore/cloud_firestore.dart';

void sendMessage(int roomId, String message, String userId) {
  FirebaseFirestore.instance.collection('rooms').doc(roomId.toString()).collection('messages').add({
    'message': message,
    'userId': userId,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

Stream<List<MessageWithUser>> getMessagesWithUserDetails(int roomId) {
  return FirebaseFirestore.instance.collection('rooms').doc(roomId.toString()).collection('messages').orderBy('timestamp').snapshots().asyncMap((snapshot) async {
    List<MessageWithUser> messages = [];
    for (var doc in snapshot.docs) {
      var messageData = doc.data();
      var userSnapshot = await FirebaseFirestore.instance.collection('users').doc(messageData['userId']).get();
      var userData = userSnapshot.data()!;
      messages.add(
        MessageWithUser(
          message: messageData['message'],
          userId: messageData['userId'],
          userName: userData['name'], // Assuming 'name' is the field in user document
          timestamp: messageData['timestamp'].toDate(),
        ),
      );
    }
    return messages;
  });
}

class MessageWithUser {
  final String message;
  final String userId;
  final String userName;
  final DateTime timestamp;

  MessageWithUser({
    required this.message,
    required this.userId,
    required this.userName,
    required this.timestamp,
  });
}
