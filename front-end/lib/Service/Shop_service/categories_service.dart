import 'dart:convert';
import 'package:appmanga/Model/Shop_Model/category_model.dart';
import 'package:appmanga/Model/Shop_Model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductCategoryService {
  final String apiUrl = "https://magiabaiser.id.vn/api/product-category";


  Future<List<ProductCategory>> fetchProductCategories() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => ProductCategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load product categories');
    }
  }
  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$apiUrl/$categoryId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products for category $categoryId');
    }
  }
}
