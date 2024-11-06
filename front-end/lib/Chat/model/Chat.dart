// models/message.dart
class Message {
  final String senderId;
  final int receiverId;
  final String messages;

  Message({required this.senderId, required this.receiverId, required this.messages});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      messages: json['messages'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'messages': messages,
    };
  }
}
