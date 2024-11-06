import 'dart:convert';
import 'dart:async';
import 'package:appmanga/Model/Manga_Model/Manga.dart';
import 'package:appmanga/Model/Manga_Model/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class CategoryService {
  static const String apiUrl = 'https://magiabaiser.id.vn/api/category';
  final http.Client client;

  CategoryService({http.Client? client}) : client = client ?? RetryClient(http.Client());

  Future<List<CategoryManga>> getCategoryList({bool useCache = true}) async {
    try {
      final response = await client.get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10)); // Thêm timeout

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        final categoryList = data.map((json) => CategoryManga.fromJson(json)).toList();
        return categoryList;
      } else {
        throw Exception('Failed to load category list: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching category list: $e');
      // Nếu gặp lỗi, chờ 0,5 giây và gọi lại hàm
      await Future.delayed(Duration(milliseconds: 500));
      return getCategoryList(useCache: useCache);
    }
  }

  Future<List<Manga>> getMangaListByCategory(int categoryId, int page) async {
    try {
      final response = await client.get(Uri.parse('$apiUrl/$categoryId?page=$page'))
          .timeout(const Duration(seconds: 10)); // Thêm timeout

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        final mangaList = data.map((json) => Manga.fromJson(json)).toList();
        return mangaList;
      } else {
        throw Exception('Failed to load manga list: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching manga list by category: $e');
      // Nếu gặp lỗi, chờ 0,5 giây và gọi lại hàm
      await Future.delayed(Duration(milliseconds: 500));
      return getMangaListByCategory(categoryId, page);
    }
  }
}
