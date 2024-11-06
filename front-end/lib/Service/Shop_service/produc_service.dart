import 'dart:convert';
import 'package:appmanga/Model/Shop_Model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductListService {
  final String baseUrl = 'https://magiabaiser.id.vn/api';
  Future<List<Product>> fetchProducts() async {
    final response =
    await http.get(Uri.parse('$baseUrl/product'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
  Future<List<Product>> getProductsByCategoryIds(List<int> categoryIds) async {
    final String categoryIdsQuery = categoryIds.map((id) => 'category_ids[]=$id').join('&');
    print(categoryIdsQuery);
    final String url = '$baseUrl/getProductsByCategoryIds?$categoryIdsQuery';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(response.body)['data'] as List;
      return data.map((productJson) => Product.fromJson(productJson)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
