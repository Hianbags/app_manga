import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> backgroundHandler(RemoteMessage message) async {
  print('Background notification received: ${message.messageId}');
  // Handle background notification
  print('Title:  ${message.notification?.title}');
  print('Body:  ${message.notification?.body}');
  print('Payload:  ${message.data}');
}

Future<void> foregroundHandler(RemoteMessage message) async {
  print('Foreground notification received: ${message.messageId}');
  // Handle foreground notification
  print('Title:  ${message.notification?.title}');
  print('Body:  ${message.notification?.body}');
  print('Payload:  ${message.data}');
}

Future<void> terminatedHandler(RemoteMessage message) async {
  print('Terminated state notification received: ${message.messageId}');
  // Handle terminated state notification
  print('Title:  ${message.notification?.title}');
  print('Body:  ${message.notification?.body}');
  print('Payload:  ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseApi() {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessage.listen(foregroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle notification that opened the app from a terminated state
      terminatedHandler(message);
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCMtoken = await _firebaseMessaging.getToken();
    print('FCMtoken: $FCMtoken');
    if (FCMtoken != null) {
      await sendTokenToServer(FCMtoken, null); // Replace null with user_id if available
    }
  }

  Future<void> sendTokenToServer(String deviceToken, int? userId) async {
    final url = Uri.parse('https://magiabaiser.id.vn/api/save-token');
    String? token = await DatabaseHelper().getToken();
    print('Token user: $token');

    final body = {
      'device_token': deviceToken,
      'user_id': userId.toString(), // Include user_id if available
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      print('Token sent successfully');
    } else {
      print('Failed to send token: ${response.statusCode}');
    }
  }
}
