import 'dart:async';
import 'dart:convert';
import 'package:appmanga/Model/Manga_Model/Manga.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart'; // Thêm gói này vào pubspec.yaml

class CategoryMangaService {
  final String baseUrl = 'https://magiabaiser.id.vn/public/api/category/';
  final http.Client client;

  CategoryMangaService({http.Client? client}) : client = client ?? RetryClient(http.Client());

  Future<Manga> fetchMangas(int categoryId, int page) async {
    try {
      final response = await client.get(
          Uri.parse('$baseUrl$categoryId?page=$page')
      ).timeout(const Duration(seconds: 10)); // Thêm timeout

      if (response.statusCode == 200) {
        return Manga.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load mangas: ${response.reasonPhrase}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Client exception: ${e.message}');
    } on TimeoutException catch (e) {
      throw Exception('Timeout exception: ${e.message}');
    } on Exception catch (e) {
      throw Exception('Failed to load mangas: $e');
    }
  }
}



