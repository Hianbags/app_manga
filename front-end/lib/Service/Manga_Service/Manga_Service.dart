import 'dart:convert';
import 'dart:async';
import 'package:appmanga/Model/Manga_Model/Manga.dart';
import 'package:appmanga/Model/Manga_Model/Search_model.dart';
import 'package:appmanga/Model/Manga_Model/banner_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class MangaService {
  static const String mangaApiUrl = 'https://magiabaiser.id.vn/api/manga';
  static List<Manga> cachedMangaList = [];
  final http.Client client;
  MangaService({http.Client? client}) : client = client ?? RetryClient(http.Client());

  Future<List<Manga>> getMangaList({int page = 1, bool useCache = true}) async {
    if (useCache && cachedMangaList.isNotEmpty) {
      return cachedMangaList;
    } else {
      try {
        final response = await client.get(Uri.parse('$mangaApiUrl?page=$page'))
            .timeout(const Duration(seconds: 10)); // Thêm timeout
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final List<dynamic> data = jsonData['data'];
          final mangaList = data.map((json) => Manga.fromJson(json)).toList();

          if (useCache) {
            cachedMangaList = mangaList; // Lưu dữ liệu vào cache
          }
          return mangaList;
        } else {
          throw Exception('Failed to load manga list: ${response.reasonPhrase}');
        }
      } catch (e) {
        // Nếu gặp lỗi, chờ 0,5 giây và gọi lại hàm
        await Future.delayed(Duration(milliseconds: 500));
        return getMangaList(page: page, useCache: useCache);
      }
    }
  }

}

class BannerService {
  static const String bannerApiUrl = 'https://magiabaiser.id.vn/api/mostview';
  static List<BannerModel> cachedBannerList = [];
  final http.Client client;

  BannerService({http.Client? client}) : client = client ?? RetryClient(http.Client());

  Future<List<BannerModel>> getBannerList({bool useCache = true}) async {
    if (useCache && cachedBannerList.isNotEmpty) {
      return cachedBannerList;
    } else {
      try {
        final response = await client.get(Uri.parse(bannerApiUrl))
            .timeout(const Duration(seconds: 10)); // Thêm timeout

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final List<dynamic> data = jsonData['data'];
          final bannerList = data.map((json) => BannerModel.fromJson(json)).toList();

          if (useCache) {
            cachedBannerList = bannerList;
          }
          print(bannerList);
          return bannerList;
        } else {
          throw Exception('Failed to load banner list: ${response.reasonPhrase}');
        }
      } catch (e) {
        print('Error fetching banner list: $e');
        return Future.delayed(Duration(milliseconds: 500), () {
          return getBannerList(useCache: useCache);
        });
      }
    }
  }
}
class SearchMangaService {
  static const String baseUrl = 'https://magiabaiser.id.vn/api';
  final http.Client client;
  SearchMangaService({http.Client? client}) : client = client ?? RetryClient(http.Client());
  Future<List<SearchManga>> searchManga(String query) async {
    print('Searching for manga with query: $query');
    try {
      final response = await client.get(Uri.parse('$baseUrl/search?title=$query'))
          .timeout(const Duration(seconds: 10)); // Thêm timeout
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        print('Data received: $data');
        return data.map((json) => SearchManga.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load manga: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error searching for manga: $e');
      await Future.delayed(Duration(milliseconds: 500));
      return searchManga(query);
    }
  }
}
class MangaCategoryService {
  final String apiUrl = 'https://magiabaiser.id.vn/api';

  Future<List<Manga>> getMangasByCategoryIds(List<int> categoryIds, int page) async {
    final String categoryIdsQuery = categoryIds.map((id) => 'category_ids[]=$id').join('&');
    print(categoryIdsQuery);
    final String url = '$apiUrl/getMangasByCategoryIds?page=$page&$categoryIdsQuery';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => Manga.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
