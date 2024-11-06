import 'dart:convert';
import 'package:appmanga/Chat/roomchat/model.dart';
import 'package:http/http.dart' as http;

Future<List<RoomChat>> fetchRooms() async {
  final response = await http.get(Uri.parse('https://magiabaiser.id.vn/api/room-chat'));
  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final List<dynamic> dataJson = jsonResponse['data'];
    return dataJson.map((json) => RoomChat.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}