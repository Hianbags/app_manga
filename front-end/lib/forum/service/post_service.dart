import 'dart:convert';
import 'dart:io';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:appmanga/forum/model/post_forum_model.dart';
import 'package:http/http.dart' as http;

class PostService {
  final String baseUrl = "https://magiabaiser.id.vn/forum/api/thread";

  Future<List<Post>> fetchPosts(int threadId) async {
    final response = await http.get(Uri.parse('$baseUrl/$threadId/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
  Future<void> postContent(String content, int threadId, {int? post, List<File>? images}) async {
    final url = Uri.parse('$baseUrl/$threadId/posts');
    String? token = await DatabaseHelper().getToken();
    final headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields['content'] = content;
    if (post != null) request.fields['post'] = post.toString();

    if (images != null) {
      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
      }
    }

    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print('Post successful');
        // You can further process the response if needed
      } else {
        print('Failed to post. Status code: ${response.statusCode}');
        print('Response body: ${responseBody.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
