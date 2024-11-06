import 'dart:convert';
import 'dart:async';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:appmanga/Model/Manga_Model/manga_detail_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class MangaDetailService {
  static const String apiUrl = 'https://magiabaiser.id.vn/public/api/manga/';
  final http.Client client;

  MangaDetailService({http.Client? client}) : client = client ?? RetryClient(http.Client());
  Future<MangaDetail> getMangaDetail(int mangaId) async {
    String? token = await DatabaseHelper().getToken();
    try {
      final response = await client.get(Uri.parse('$apiUrl$mangaId'),
        headers: {
        'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final mangaDetail = MangaDetail.fromJson(jsonData['data']);
        return mangaDetail;
      } else {
        throw Exception('Failed to load manga detail: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching manga detail: $e');
      // Nếu gặp lỗi, chờ 0,5 giây và gọi lại hàm
      await Future.delayed(Duration(milliseconds: 500));
      return getMangaDetail(mangaId);
    }
  }
}
