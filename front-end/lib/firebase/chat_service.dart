import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessages() {
    return _firestore.collection('messages').orderBy('timestamp').snapshots();
  }

  Future<void> sendMessage(String message) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('messages').add({
        'text': message,
        'sender': user.displayName,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}
