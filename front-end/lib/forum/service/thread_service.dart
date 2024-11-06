import 'dart:convert';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:appmanga/forum/model/thread_forum_model.dart';
import 'package:http/http.dart' as http;

class ThreadService {
  final String baseUrl = "https://magiabaiser.id.vn/forum/api/category";

  Future<List<Thread>> fetchThreads(int categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/$categoryId/thread'));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((thread) => Thread.fromJson(thread)).toList();
      } catch (e) {
        throw Exception('Failed to parse threads: $e');
      }
    } else {
      throw Exception('Failed to load threads: ${response.reasonPhrase}');
    }
  }

  Future<void> postThread(int categoryId, String title, String content) async {
    final String url = "$baseUrl/$categoryId/thread";
    String? token = await DatabaseHelper().getToken();
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      print("Thread created successfully");
    } else {
      // Log the response body for more details
      print('Failed to create thread: ${response.body}');
      throw Exception('Failed to create thread: ${response.reasonPhrase}');
    }
  }
}
