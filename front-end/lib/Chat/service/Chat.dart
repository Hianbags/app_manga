import 'dart:async';
import 'dart:convert';
import 'package:appmanga/Chat/model/Chat.dart';
import 'package:appmanga/Chat/model/user.dart';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:http/http.dart' as http;

class ChatService {
  Future<List<UserChatList>> loadAllUsers() async {
    String? token = await DatabaseHelper().getToken();
    final response = await http.get(Uri.parse('https://magiabaiser.id.vn/api/communications'),
        headers: {
          'Authorization' : 'Bearer $token',
        }
    );
    if (response.statusCode == 200) {
      print('Response status code: 200');
      List<dynamic> body = jsonDecode(response.body);
      print('Response body: $body');
      return body.map((item) => UserChatList.fromJson(item)).toList();
    } else {
      print('Failed to load all users. Status code: ${response.statusCode}');
      print('Response body: ${response.body}')  ;
      throw Exception('Failed to load all users');
    }
  }
  static const String _baseUrl = 'http://magiakiwi.xyz/api';
  static Future<bool> sendMessage(Message message) async {
    final token = await DatabaseHelper().getToken();
    final response = await http.post(
    Uri.parse('$_baseUrl/send-messages'),
    headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
    },
  body: jsonEncode(message.toJson()),
  );
  return response.statusCode == 200;
  }

}
