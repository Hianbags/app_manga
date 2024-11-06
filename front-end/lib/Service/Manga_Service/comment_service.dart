import 'dart:convert';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:appmanga/Model/Manga_Model/comment_model.dart';
import 'package:http/http.dart' as http;

class CommentService {
  final String baseUrl = "http://magiabaiser.id.vn/api/comment";
  Future<CommentResponse> fetchComments(int mangaId) async {
    final response = await http.get(Uri.parse('$baseUrl/$mangaId'));

    if (response.statusCode == 200) {
      return CommentResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load comments');
    }
  }
}

class AddCommentService {
  final String baseUrl = 'http://magiabaiser.id.vn/api/comment';

  Future<void> addComment(int mangaId, String content) async {
    String? token = await DatabaseHelper().getToken();
    final response = await http.post(Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'manga_id': mangaId,
        'content': content,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Comment added successfully');
    } else {
      // Handle error
      throw Exception('Failed to add comment');
    }
  }
}
