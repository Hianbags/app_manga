import 'dart:convert';
import 'dart:async';
import 'package:appmanga/Model/Manga_Model/page_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class ChapterService {
  static const String apiUrl = 'https://magiabaiser.id.vn/api/chapter/';
  final http.Client client;

  ChapterService({http.Client? client}) : client = client ?? RetryClient(http.Client());

  Future<List<PageModel>> fetchChapterPages(int chapterId) async {
    try {
      final response = await client.get(Uri.parse('$apiUrl$chapterId/page'))
          .timeout(const Duration(seconds: 10)); // Thêm timeout

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> data = jsonData['data'];
        return data.map((json) => PageModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load chapter pages: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching chapter pages: $e');
      // Nếu gặp lỗi, chờ 0,5 giây và gọi lại hàm
      await Future.delayed(Duration(milliseconds: 500));
      return fetchChapterPages(chapterId);
    }
  }
}
