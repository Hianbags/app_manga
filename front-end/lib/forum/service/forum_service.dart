import 'dart:convert';
import 'package:appmanga/forum/model/category_forum_model.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = "https://magiabaiser.id.vn/forum/api/category";

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

// Add more methods for other actions if needed
}
