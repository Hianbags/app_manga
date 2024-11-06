import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<String> signUpUser({required String email,
    required String password,
    required String name }) async {
    String res = 'error';
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': userCredential.user!.uid,
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({required String email, required String password}) async {
    String res = 'error';
    try {
       await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }

}